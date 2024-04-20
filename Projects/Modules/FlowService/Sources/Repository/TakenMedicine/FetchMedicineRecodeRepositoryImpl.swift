// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService
import Model

import RxSwift

class FetchMedicineRecodeRepositoryImpl: FetchMedicineRecodeRepository {
    var dataBase: TakenMedicineDataSource

    init(dataBase: TakenMedicineDataSource) {
        self.dataBase = dataBase
    }
    
    public func fetchMedicineRecode() -> Single<MedicineRecodeEntity?> {
        dataBase.fetchMedicineRecode()
    }
}
