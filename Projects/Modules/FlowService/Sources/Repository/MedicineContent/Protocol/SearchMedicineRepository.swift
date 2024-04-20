// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model
import RemoteService

import RxSwift

public protocol SearchMedicineRepository {
    var dataSource: MedicineContentDataSource { get }

    func searchMedicine(with name: String) -> Single<[MedicineInfoEntity]>
}
