import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()

    struct Input { 
        let viewWillAppear: Observable<Void>
    }
    
    struct Output { }

    init() {}

    func transform(input: Input) -> Output {
        return Output()
    }
}
