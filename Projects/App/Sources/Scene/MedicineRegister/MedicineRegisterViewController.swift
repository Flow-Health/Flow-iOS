import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class MedicineRegisterViewController: BaseVC<MedicineRegisterViewModel> {

    private let nameStepView = NameRegisterStepView()
    private let descriptionRegisterStepView = DescriptionRegisterStepView()
    private let imageRegisterStepView = ImageRegisterStepView()
    private let endRegisterStepView = EndRegisterStepView()
    
    private let registerStepViewStack: [BaseView]

    private let backButton = BaseButton().then {
        $0.setImage(FlowKitAsset.backArrow.image, for: .normal)
    }

    override init(viewModel: MedicineRegisterViewModel) {
        registerStepViewStack = [
            nameStepView,
            descriptionRegisterStepView,
            imageRegisterStepView,
            endRegisterStepView
        ]

        super.init(viewModel: viewModel)
    }
    
    deinit {
        registerStepViewStack.forEach {
            $0.removeFromSuperview()
        }
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bind() {

        let nextButtonTap = Observable.merge(
            nameStepView.nextButton.rx.tap.asObservable(),
            nameStepView.keyboardNextButton.rx.tap.asObservable(),
            descriptionRegisterStepView.nextButton.rx.tap.asObservable(),
            descriptionRegisterStepView.keyboardNextButton.rx.tap.asObservable()
        )

        let input = MedicineRegisterViewModel.Input(
            onTapBackButton: backButton.rx.tap.asObservable(),
            onTapNextButton: nextButtonTap,
            onTapCreateMedicineButton: imageRegisterStepView.addMedicineButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.currentStep.asObservable()
            .subscribe(onNext: { [weak self] step in
                guard let self else { return }
                registerStepViewStack.forEach { $0.isHidden = true }
                registerStepViewStack[step.rawValue - 1].isHidden = false
            })
            .disposed(by: disposeBag)

        output.dismissView.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        endRegisterStepView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubViews(registerStepViewStack + [backButton, endRegisterStepView])
    }

    override func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(22)
        }

        endRegisterStepView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        [nameStepView, descriptionRegisterStepView, imageRegisterStepView].forEach { stepView in
            stepView.snp.makeConstraints {
                $0.top.equalTo(backButton.snp.bottom).offset(35)
                $0.bottom.horizontalEdges.equalToSuperview()
            }
        }
    }
}
