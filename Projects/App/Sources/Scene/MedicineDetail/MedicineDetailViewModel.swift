import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class MedicineDetailViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()

    var disposeBag: DisposeBag = .init()

    struct Input { }
    
    struct Output { }

    init() {}

    func transform(input: Input) -> Output {
        return Output()
    }
}
