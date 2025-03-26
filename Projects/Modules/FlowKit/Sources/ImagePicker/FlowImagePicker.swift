// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import RxGesture

import SnapKit
import Then

open class FlowImagePicker: BaseView {

    private let disposeBag = DisposeBag()
    public let selectedImageRelay = BehaviorRelay<UIImage?>(value: nil)

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }

    private let setDefaultImageButton = BaseButton().then {
        $0.setTitle("기본 이미지 사용", for: .normal)
        $0.setTitleColor(.blue1, for: .normal)
        $0.titleLabel?.font = .bodyB2SemiBold
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.blue1.cgColor
        $0.layer.cornerRadius = 10
    }

    open override func bind() {
        setDefaultImageButton.rx.tap
            .map { _ in nil }
            .bind(to: selectedImageRelay)
            .disposed(by: disposeBag)

        selectedImageRelay
            .map {
                guard let image = $0 else { return FlowKitAsset.defaultImage.image }
                return image
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)

        imageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in self?.onTapSelectImage() })
            .disposed(by: disposeBag)
    }

    open override func addView() {
        addSubViews(imageView, setDefaultImageButton)
    }

    open override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(220)
        }

        setDefaultImageButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(37)
        }

        self.snp.makeConstraints {
            $0.bottom.equalTo(setDefaultImageButton)
        }
    }
}

extension FlowImagePicker {
    private func onTapSelectImage() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self

        if let topVC = UIApplication.topViewController() {
            topVC.present(imagePicker, animated: true)
        }
    }
}

extension FlowImagePicker: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let imageProvider = results.first?.itemProvider

        if let imageProvider = imageProvider,
           imageProvider.canLoadObject(ofClass: UIImage.self) {
            imageProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.selectedImageRelay.accept(image as? UIImage)
                }
            }
        }
    }
}

#Preview(body: {
    FlowImagePicker()
})
