// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService

import RxSwift

class InsertTakenMedicineRepositoryImpl: InsertTakenMedicineRepository {
    var dataBase: TakenMedicineDataSource

    init(dataBase: TakenMedicineDataSource) {
        self.dataBase = dataBase
    }
    
    public func insertTakenMedicine(with itemCode: String, at time: Date) -> Completable {
        dataBase.insertTakenMedicine(with: itemCode, at: time)
    }
}
