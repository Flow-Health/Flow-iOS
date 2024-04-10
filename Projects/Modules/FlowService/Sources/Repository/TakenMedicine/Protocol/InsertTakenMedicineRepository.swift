// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService

import RxSwift

public protocol InsertTakenMedicineRepository {
    var dataBase: TakenMedicineDataSource { get set }

    func insertTakenMedicine(with itemCode: String, at time: Date) -> Completable
}
