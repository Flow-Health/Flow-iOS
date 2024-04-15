import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()

    struct Input { }
    
    struct Output { }

    init() {}

    func transform(input: Input) -> Output {
        return Output()
    }
}
