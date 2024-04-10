// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

public protocol FindBookMarkMedicineRepository {
    var dataSource: BookMarkMedicineDataSource { get }

    func findBookMarkMedicine(with itemCode: String) -> Single<MedicineInfoEntity?>
}
