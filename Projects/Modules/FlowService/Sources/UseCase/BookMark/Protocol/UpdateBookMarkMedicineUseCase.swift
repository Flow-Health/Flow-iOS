// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

public protocol UpdateBookMarkMedicineUseCase {
    var repository: UpdateBookMarkMedicineRepository { get set }

    func execute(to entity: MedicineInfoEntity, at itemCode: String) -> Completable
}
