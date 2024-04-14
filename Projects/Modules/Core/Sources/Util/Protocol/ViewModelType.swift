// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift

public protocol ViewModelType {
    var disposeBag: DisposeBag { get set }

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
