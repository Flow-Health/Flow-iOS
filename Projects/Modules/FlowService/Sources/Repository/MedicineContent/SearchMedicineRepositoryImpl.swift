// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model
import RemoteService

import RxSwift

class SearchMedicineRepositoryImpl: SearchMedicineRepository {
    var dataSource: MedicineContentDataSource

    init(dataSource: MedicineContentDataSource) {
        self.dataSource = dataSource
    }

    func searchMedicine(with name: String) -> Single<[MedicineInfoEntity]> {
        dataSource.searchMedicine(with: name)
            .map { $0.map { $0.toDomain() } }
    }
}
