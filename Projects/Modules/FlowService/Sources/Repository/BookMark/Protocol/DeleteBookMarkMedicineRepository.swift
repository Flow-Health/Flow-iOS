// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

public protocol DeleteBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource { get }

    func deleteBookMarkMedicine(with itemCode: String) -> Completable
}
