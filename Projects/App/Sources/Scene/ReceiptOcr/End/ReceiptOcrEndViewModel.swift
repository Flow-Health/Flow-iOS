// Copyright © 2025 com.flow-health. All rights reserved.

import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class ReceiptOcrEndViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    struct Input {
        let tapCloseButton: Observable<Void>
    }
    
    struct Output {
    }

    init() {}

    func transform(input: Input) -> Output {
        input.tapCloseButton
            .map { FlowStep.homeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output()
    }
}
