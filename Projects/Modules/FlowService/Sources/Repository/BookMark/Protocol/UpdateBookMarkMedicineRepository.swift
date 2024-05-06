// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

public protocol UpdateBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource { get }

    func updateBookMarkMedicine(to entity: MedicineInfoEntity, at itemCode: String) -> Completable
}
