// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

class FindBookMarkMedicineRepositoryImpl: FindBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource

    init(dataSource: BookMarkMedicineDataSource) {
        self.dataSource = dataSource
    }

    func findBookMarkMedicine(with itemCode: String) -> Single<MedicineInfoEntity?> {
        dataSource.findBookMarkMedicine(with: itemCode)
    }
}
