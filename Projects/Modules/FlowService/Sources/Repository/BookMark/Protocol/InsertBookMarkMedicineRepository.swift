// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

public protocol InsertBookMarkMedicineRepository {
    var bookMarkMedicineDataSource: BookMarkMedicineDataSource { get }
    var medicineTypeDataSource: MedicineTypeDataSource { get }

    func insertBookMarkMedicine(with entity: MedicineInfoEntity) -> Completable
}
