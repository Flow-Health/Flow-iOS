import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa

class SomeViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()

    struct Input { }
    
    struct Output { }

    init() {}

    func transform(input: Input) -> Output {
        return Output()
    }
}