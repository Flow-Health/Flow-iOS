// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService
import Model

import RxSwift

public protocol FetchTakenMedicineListRepository {
    var dataBase: TakenMedicineDataSource { get set }

    func fetchTakenMedicineList(at date: Date) -> Single<[MedicineTakenEntity]>
}
