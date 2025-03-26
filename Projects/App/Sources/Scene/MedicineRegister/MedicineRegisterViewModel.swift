import Foundation
import RxFlow
import FlowService
import Model
import Core

import RxSwift
import RxCocoa

enum RegisterStepType: Int {
    case NAME = 1, DESCRIPTION, IMAGE, END
}

class MedicineRegisterViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    struct Input {
        let onTapBackButton: Observable<Void>
        let onTapNextButton: Observable<Void>
        let onTapCreateMedicineButton: Observable<Void>
    }
    
    struct Output {
        let currentStep: Driver<RegisterStepType>
        let dismissView: Signal<Void>
    }

    init() {}

    func transform(input: Input) -> Output {
        let currentStepRelay = BehaviorRelay<RegisterStepType>(value: .NAME)
        let dismissViewRelay = PublishRelay<Void>()

        input.onTapNextButton
            .map { _ -> RegisterStepType in
                guard let nextStep = RegisterStepType(rawValue: currentStepRelay.value.rawValue + 1) else { return .NAME }
                return nextStep
            }
            .bind(to: currentStepRelay)
            .disposed(by: disposeBag)

        input.onTapBackButton
            .map { RegisterStepType(rawValue: currentStepRelay.value.rawValue - 1) }
            .subscribe(onNext: { step in
                if let step {
                    currentStepRelay.accept(step)
                } else {
                    dismissViewRelay.accept(())
                }
            })
            .disposed(by: disposeBag)

        return Output(
            currentStep: currentStepRelay.asDriver(),
            dismissView: dismissViewRelay.asSignal()
        )
    }
}
