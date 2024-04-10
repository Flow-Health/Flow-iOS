// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

public protocol DeleteBookMarkMedicineUseCase {
    var repository: DeleteBookMarkMedicineRepository { get set }

    func execute(with itemCode: String) -> Completable
}
