// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

class InsertBookMarkMedicineRepositoryImpl: InsertBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource

    init(dataSource: BookMarkMedicineDataSource) {
        self.dataSource = dataSource
    }

    func insertBookMarkMedicine(with entity: MedicineInfoEntity) -> Completable {
        dataSource.insertBookMarkMedicine(with: entity)
    }
}
