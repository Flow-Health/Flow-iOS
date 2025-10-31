// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import AVFoundation
import VisionKit
import Vision

import RxSwift
import RxCocoa

class ReceiptOcrScanViewController: BaseVC<ReceiptOcrScanViewModel> {

    private let ocrTextListRelay = PublishRelay<[String]>()
    private let scanbuttonTrigger = PublishRelay<Void>()

    private let subTitle = UILabel().then {
        $0.customLabel("처방전 스캔", font: .bodyB2SemiBold, textColor: .blue1)
    }

    private let mainTitle = UILabel().then {
        $0.customLabel("처방전을 촬영하세요.", font: .headerH2SemiBold)
    }

    private let previewFrameView = UIView().then {
        $0.layer.borderWidth = 1
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

    private let dimView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
        $0.isHidden = true
    }

    private let loadingLabel = UILabel().then {
        $0.customLabel("사진 분석중...", font: .bodyB2Medium, textColor: .white)
    }

    private let loadingIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.startAnimating()
        $0.color = .white
    }

    private let guideButton = FlowPaddingButton(buttonTitle: "사진 촬영방법")
    private let guideViewController = OcrScanGuideViewController()

    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    private var session: AVCaptureSession?
    private var photoOutput = AVCapturePhotoOutput()
    private var preview: AVCaptureVideoPreviewLayer?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCamera()
    }

    override func attridute() {
        // 카메라 세팅
        Task {
            do {
                try await settingCamera()

                // 최초 진입시, 가이드 노출
                present(guideViewController, animated: true)
            } catch {
                canNotAllowCamLabel.isHidden = false

                guard let error = error as? OcrError else { return }
                presentErrorAlert(error)
            }
        }
    }

    override func bind() {
        let input = ReceiptOcrScanViewModel.Input(
            ocrTextList: ocrTextListRelay.asObservable(),
            tapScanButton: scanbuttonTrigger.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.OcrError
            .withUnretained(self)
            .emit(onNext: { (owner, error) in
                owner.presentErrorAlert(error)
                owner.startCamera()
            })
            .disposed(by: disposeBag)

        output.isLoading
            .drive(
                with: self,
                onNext: { (owner, status) in
                    owner.scanButton.isEnabled = !status
                    owner.dimView.isHidden = !status
                }
            )
            .disposed(by: disposeBag)

        scanButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self, session != nil else { return }
                let setting = AVCapturePhotoSettings()
                scanbuttonTrigger.accept(())
                photoOutput.capturePhoto(with: setting, delegate: self)
            }).disposed(by: disposeBag)

        guideButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.present(owner.guideViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubViews(
            subTitle,
            mainTitle,
            previewFrameView,
            scanButton,
            guideButton,
            dimView
        )
        dimView.addSubViews(loadingIndicator, loadingLabel)
        previewFrameView.addSubview(canNotAllowCamLabel)
        scanButton.addSubview(scanButtonCircle)
    }

    override func setAutoLayout() {
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
            $0.height.equalTo(previewFrameView.snp.width)
            $0.top.equalTo(mainTitle.snp.bottom).offset(50)
        }

        canNotAllowCamLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(5)
        }

        guideButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(scanButton.snp.top).offset(-15)
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

        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }

        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loadingIndicator.snp.bottom).offset(10)
        }
    }
}

// MARK: 카메라 예외처리
extension ReceiptOcrScanViewController {
    private func presentErrorAlert(_ error: OcrError) {
        let alert = UIAlertController(title: "오류", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)

        // 카메라 권한 설정 오류일때, 설정으로 이동 action 추가
        switch error {
        case .noAuthorization:
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

// MARK: 카메라 설정 및 촬영
extension ReceiptOcrScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {

    private func settingCamera() async throws {
        guard await AVCaptureDevice.requestAccess(for: .video) else {
            throw OcrError.noAuthorization
        }

        guard let captureDevice else { throw OcrError.noCaptureDevice }

        do {
            let photoInput = try AVCaptureDeviceInput(device: captureDevice)
            session = AVCaptureSession()
            session?.beginConfiguration()
            session?.sessionPreset = .photo
            session?.addInput(photoInput)
            session?.addOutput(photoOutput)
            session?.commitConfiguration()
        } catch {
            throw OcrError.cameraSettingFailed
        }

        guard let session else { throw OcrError.noSession }

        self.preview = AVCaptureVideoPreviewLayer(session: session)
        guard let previewLayer = self.preview else { throw OcrError.someError(message: "No Preview") }
        
        previewLayer.videoGravity = .resizeAspectFill
        self.previewFrameView.layer.addSublayer(previewLayer)
        previewLayer.frame = self.previewFrameView.bounds

        Task.detached {
            session.startRunning()
        }
    }

    func startCamera() {
        guard let session else { return }
        DispatchQueue.global().async {
            session.startRunning()
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {

        // 카메라 작동 중지
        session?.stopRunning()

        guard let imageData = photo.fileDataRepresentation(),
              let outputImage = UIImage(data: imageData),
              let cgOutputImage = outputImage.cgImage,
              error == nil
        else {
            presentErrorAlert(.captureFailed)
            return
        }

        // previewFrameView에 들어간 사진 비율 구하기
        guard let previewLayer = self.preview else {
            presentErrorAlert(.noPreview)
            return
        }
        let nomalRect = previewLayer.metadataOutputRectConverted(fromLayerRect: self.previewFrameView.bounds)
        let (imageWidth, imageHeight) = (CGFloat(cgOutputImage.width), CGFloat(cgOutputImage.height))

        // 이미지 크롭 진행
        guard let cropCgIamge = cgOutputImage.cropping(to:
                .init(x: nomalRect.minX * imageWidth,
                      y: nomalRect.minY * imageHeight,
                      width: nomalRect.width * imageWidth,
                      height: nomalRect.height * imageHeight))
        else { return }

        // cropCgIamge -> UIImage 변환
        let cropImage = UIImage(cgImage: cropCgIamge, scale: outputImage.scale, orientation: outputImage.imageOrientation)

        // OCR 진행
        recognizeText(cropImage)
    }
}

// MARK: 이미지 OCR
extension ReceiptOcrScanViewController {
    private func recognizeText(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { [weak self] request, error in

            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }

            let texts = observations.compactMap { $0.topCandidates(1).first?.string }

            // OCR후 ViewModel에 전달
            self?.ocrTextListRelay.accept(texts)
        }

        request.revision = VNRecognizeTextRequestRevision3
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR", "en-US"]
        request.usesLanguageCorrection = true

        try? handler.perform([request])
    }
}
