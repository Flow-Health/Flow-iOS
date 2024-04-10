// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

public protocol InsertBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource { get }

    func insertBookMarkMedicine(with entity: MedicineInfoEntity) -> Completable
}
