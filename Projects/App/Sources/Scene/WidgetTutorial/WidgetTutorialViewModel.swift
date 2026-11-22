// Copyright © 2026 com.flow-health. All rights reserved.

import Foundation
import Core

import RxSwift
import RxCocoa
import RxFlow

class WidgetTutorialViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    struct Input {
        let viewDidLoad: Observable<Void>
        let currentPage: Observable<Int>
        let tapNextButton: Observable<Void>
    }

    struct Output {
        let tutorialSteps: Driver<[WidgetTutorialStep]>
        let currentPage: Driver<Int>
        let isLastPage: Driver<Bool>
        let moveToPage: Signal<Int>
    }

    init() {}

    func transform(input: Input) -> Output {
        let tutorialSteps = WidgetTutorialStep.allCases
        let lastPage = tutorialSteps.count - 1
        let currentPage = BehaviorRelay<Int>(value: 0)
        let moveToPage = PublishRelay<Int>()

        input.currentPage
            .map { min(max($0, 0), lastPage) }
            .distinctUntilChanged()
            .bind(to: currentPage)
            .disposed(by: disposeBag)

        input.tapNextButton
            .withLatestFrom(currentPage)
            .subscribe(with: self, onNext: { owner, page in
                if page < lastPage {
                    moveToPage.accept(page + 1)
                } else {
                    owner.steps.accept(FlowStep.widgetTutorialIsCompleted)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            tutorialSteps: input.viewDidLoad.map { tutorialSteps }.asDriver(onErrorJustReturn: []),
            currentPage: currentPage.asDriver(),
            isLastPage: currentPage.map { $0 == lastPage }.asDriver(onErrorJustReturn: false),
            moveToPage: moveToPage.asSignal()
        )
    }
}
