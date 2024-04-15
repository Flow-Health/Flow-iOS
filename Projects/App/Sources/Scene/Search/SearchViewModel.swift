import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class SearchViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()

    var disposeBag: DisposeBag = .init()

    struct Input { }
    
    struct Output { }

    init() {}

    func transform(input: Input) -> Output {
        return Output()
    }
}
