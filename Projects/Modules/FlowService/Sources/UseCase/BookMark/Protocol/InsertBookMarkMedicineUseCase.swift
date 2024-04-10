// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

public protocol InsertBookMarkMedicineUseCase {
    var repository: InsertBookMarkMedicineRepository { get set }

    func execute(with entity: MedicineInfoEntity) -> Completable
}
