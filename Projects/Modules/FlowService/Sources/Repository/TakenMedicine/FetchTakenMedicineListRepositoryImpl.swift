// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService
import Model
import Core

import RxSwift

class FetchTakenMedicineListRepositoryImpl: FetchTakenMedicineListRepository {
    var dataBase: TakenMedicineDataSource

    init(dataBase: TakenMedicineDataSource) {
        self.dataBase = dataBase
    }

    public func fetchTakenMedicineList(at date: Date) -> Single<[MedicineTakenEntity]> {
        dataBase.fetchTakenMedicineList()
            .map { $0.filter { $0.takenTime.toString(.fullDate) == date.toString(.fullDate) } }
    }
}
