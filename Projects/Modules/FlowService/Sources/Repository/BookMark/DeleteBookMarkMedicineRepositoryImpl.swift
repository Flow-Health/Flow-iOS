// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

class DeleteBookMarkMedicineRepositoryImpl: DeleteBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource

    init(dataSource: BookMarkMedicineDataSource) {
        self.dataSource = dataSource
    }

    func deleteBookMarkMedicine(with itemCode: String) -> Completable {
        dataSource.deleteBookMarkMedicine(with: itemCode)
    }
}
