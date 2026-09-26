// Copyright © 2026 com.flow-health. All rights reserved.

import Foundation
import LocalService

import RxSwift

class DeleteTakenMedicineRepositoryImpl: DeleteTakenMedicineRepository {
    var dataBase: TakenMedicineDataSource

    init(dataBase: TakenMedicineDataSource) {
        self.dataBase = dataBase
    }

    public func deleteTakenMedicine(rowIDs: [Int64]) -> Completable {
        dataBase.deleteTakenMedicine(rowIDs: rowIDs)
    }
}
