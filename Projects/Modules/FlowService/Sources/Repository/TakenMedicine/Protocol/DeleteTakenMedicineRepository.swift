// Copyright © 2026 com.flow-health. All rights reserved.

import Foundation
import LocalService

import RxSwift

public protocol DeleteTakenMedicineRepository {
    var dataBase: TakenMedicineDataSource { get set }

    func deleteTakenMedicine(rowIDs: [Int64]) -> Completable
}
