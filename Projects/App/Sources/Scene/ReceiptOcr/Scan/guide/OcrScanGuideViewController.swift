// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Core

import Then
import RxSwift
import RxCocoa

class OcrScanGuideViewController: UIViewController, HasDisposeBag  {

    var disposeBag = DisposeBag()

    private let guideImageView = UIImageView().then {
        $0.image = FlowKitAsset.ocrScanGuide.image
        $0.contentMode = .scaleAspectFit
    }

    private let stepStack = VStack(spacing: 15)

    private let firstStepLabel = UILabel().then {
        let text = "1. 카메라를 처방전의 빨간 부분에 맞추어 주세요."
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(
            [.foregroundColor: UIColor.red, .font: UIFont.bodyB1Bold],
            range: (text as NSString).range(of: "빨간 부분")
        )

        $0.text = text
        $0.font = .bodyB1SemiBold
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.attributedText = attributedString
    }

    private let secondStepLabel = UILabel().then {
        $0.customLabel(
            "2. 하단의 파란색 촬영 버튼을 눌러주세요.",
            font: .bodyB1SemiBold,
            textColor: .white
        )
        $0.numberOfLines = 0
    }

    private let lastStepLabel = UILabel().then {
        $0.customLabel(
            "3. 다음 화면에서 원하는 약을 선택하고 추가해주세요.",
            font: .bodyB1SemiBold,
            textColor: .white
        )
        $0.numberOfLines = 0
    }

    private let captionLabel = UILabel().then {
        $0.customLabel(
            "⚠︎ 정해진 부분을 촬영하지 않으면 올바른 결과가 나오지 않을 수 있습니다.",
            font: .captionC2Bold,
            textColor: .white
        )
        $0.numberOfLines = 0
    }

    private let closeButton = FlowNextButton(title: "이해했습니다")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .black.withAlphaComponent(0.6)
        bind()
        addView()
        setAutoLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        closeButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
                .inset(view.safeAreaInsets.bottom > 0 ? 0 : 10)
        }

        guideImageView.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
                .inset(view.safeAreaInsets.top > 25 ? 50 : 20)
        }
    }

    func bind() {
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    func addView() {
        view.addSubViews(
            guideImageView,
            stepStack,
            captionLabel,
            closeButton
        )

        stepStack.addArrangedSubviews(
            firstStepLabel,
            secondStepLabel,
            lastStepLabel
        )
    }

    func setAutoLayout() {
        guideImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.horizontalEdges.equalToSuperview().inset(60)
            $0.height.equalTo(guideImageView.snp.width).multipliedBy(1.41)
        }

        stepStack.snp.makeConstraints {
            $0.top.equalTo(guideImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }

        captionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(closeButton.snp.top).offset(-15)
        }

        closeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
