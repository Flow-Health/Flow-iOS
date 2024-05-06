// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

class UpdateBookMarkMedicineRepositoryImpl: UpdateBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource

    init(dataSource: BookMarkMedicineDataSource) {
        self.dataSource = dataSource
    }

    func updateBookMarkMedicine(to entity: MedicineInfoEntity, at itemCode: String) -> Completable {
        dataSource.updateBookMarkMedicine(to: entity, at: itemCode)
    }
}
