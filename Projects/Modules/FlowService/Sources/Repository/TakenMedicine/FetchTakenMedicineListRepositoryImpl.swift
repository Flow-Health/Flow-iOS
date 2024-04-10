// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService
import Model

import RxSwift

public class FetchTakenMedicineListRepositoryImpl: FetchTakenMedicineListRepository {
    public var dataBase: TakenMedicineDataSource

    init(dataBase: TakenMedicineDataSource) {
        self.dataBase = dataBase
    }

    public func fetchTakenMedicineList() -> Single<[MedicineTakenEntity]> {
        dataBase.fetchTakenMedicineList()
    }
}
