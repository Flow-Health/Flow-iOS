// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

public protocol FetchBookMarkMedicineListRepository {
    var dataSource: BookMarkMedicineDataSource { get }

    func fetchBookMarkMedicineList() -> Single<[MedicineInfoEntity]>
}
