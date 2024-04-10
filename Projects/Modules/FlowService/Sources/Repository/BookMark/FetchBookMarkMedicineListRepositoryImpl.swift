// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

class FetchBookMarkMedicineListRepositoryImpl: FetchBookMarkMedicineListRepository {
    var dataSource: BookMarkMedicineDataSource

    init(dataSource: BookMarkMedicineDataSource) {
        self.dataSource = dataSource
    }

    func fetchBookMarkMedicineList() -> Single<[MedicineInfoEntity]> {
        dataSource.fetchBookMarkMedicineList()
    }
}
