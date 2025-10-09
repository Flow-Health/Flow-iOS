// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import AVFoundation
import VisionKit
import Vision

class ReceiptOcrViewController: BaseVC<ReceiptOcrViewModel> {

    private let subTitle = UILabel().then {
        $0.customLabel("처방전 스캔", font: .bodyB2SemiBold, textColor: .blue1)
    }

    private let mainTitle = UILabel().then {
        $0.customLabel("처방전을 촬영하세요.", font: .headerH2SemiBold)
    }

    private let previewFrameView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.blue1.cgColor
        $0.clipsToBounds = true
    }

    private let canNotAllowCamLabel = UILabel().then {
        $0.customLabel("카메라 권한 설정을 확인해주세요.", font: .bodyB2SemiBold, textColor: .black2)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    private let scanButton = BaseButton().then {
        $0.backgroundColor = .blue1
        $0.layer.cornerRadius = 35
    }

    private let scanButtonCircle = UIView().then {
        $0.backgroundColor = .blue1
        $0.layer.cornerRadius = 29
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.isUserInteractionEnabled = false
    }

    private let testImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    private var session: AVCaptureSession?
    private var output = AVCapturePhotoOutput()

    override func attridute() {
        // 카메라 세팅
        Task {
            do {
                try await settingCamera()
            } catch {
                canNotAllowCamLabel.isHidden = false

                guard let error = error as? OcrError else { return }
                presentErrorAlert(error)
            }
        }
    }

    override func bind() {
        scanButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let setting = AVCapturePhotoSettings()
                output.capturePhoto(with: setting, delegate: self)
            }).disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubViews(subTitle, mainTitle, previewFrameView, scanButton, testImageView)
        previewFrameView.addSubview(canNotAllowCamLabel)
        scanButton.addSubview(scanButtonCircle)
    }

    override func setLayout() {
        subTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        mainTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subTitle.snp.bottom).offset(6)
        }

        previewFrameView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(view.frame.width - 50 * 2)
            $0.height.equalTo(previewFrameView.snp.width).multipliedBy(1.414)
            $0.top.equalTo(mainTitle.snp.bottom).offset(30)
        }

        canNotAllowCamLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(5)
        }

        scanButton.snp.makeConstraints {
            $0.size.equalTo(70)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }

        scanButtonCircle.snp.makeConstraints {
            $0.size.equalTo(58)
            $0.center.equalToSuperview()
        }

        testImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: 카메라 예외처리
extension ReceiptOcrViewController {
    enum OcrError: Error {
        case cameraSettingFailed, noAuthorization, noCaptureDevice, noSession, captureFailed, someError(message: String)

        var alertMessage: String {
            switch self {
            case .cameraSettingFailed:
                return "카메라 접근에 실패하였습니다."
            case .noAuthorization:
                return "카메라 접근을 허용으로 변경해주세요."
            case .noCaptureDevice:
                return "예상치 못한 오류가 발생하였습니다. (CaptureDevice Error)"
            case .noSession:
                return "예상치 못한 오류가 발생하였습니다. (noSession Error)"
            case .captureFailed:
                return "사진 촬영에 실패하였습니다."
            case let .someError(message):
                return message
            }
        }
    }

    private func presentErrorAlert(_ error: OcrError) {
        let alert = UIAlertController(title: "오류", message: error.alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)

        // 카메라 권한 설정 오류일때, 설정으로 이동 action 추가
        switch error {
        case .cameraSettingFailed:
            let goSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.addAction(goSettingAction)
        default:
            alert.addAction(okAction)
        }

        present(alert, animated: true)
    }
}

// MARK: 이미지 OCR
extension ReceiptOcrViewController {

    private func recognizeText(_ image: UIImage) {
        
        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self else { return }
            
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }

            let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            print(text)
        }

        request.revision = VNRecognizeTextRequestRevision3
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR", "en-US"]
        request.usesLanguageCorrection = true

        try? handler.perform([request])
    }
}

// MARK: 카메라 설정 및 촬영
extension ReceiptOcrViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    private func settingCamera() async throws {
        guard await AVCaptureDevice.requestAccess(for: .video) else {
            throw OcrError.noAuthorization
        }

        guard let captureDevice else { throw OcrError.noCaptureDevice }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.beginConfiguration()
            session?.sessionPreset = .photo
            session?.addInput(input)
            session?.addOutput(output)
            session?.commitConfiguration()
        } catch {
            throw OcrError.cameraSettingFailed
        }

        guard let session else { throw OcrError.noSession }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewFrameView.layer.addSublayer(previewLayer)
        previewLayer.frame = self.previewFrameView.bounds

        Task.detached {
            session.startRunning()
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData),
              error == nil
        else {
            presentErrorAlert(.captureFailed)
            return
        }

        session?.stopRunning()

        recognizeText(image)
        testImageView.image = image
        testImageView.isHidden = false
    }
}
