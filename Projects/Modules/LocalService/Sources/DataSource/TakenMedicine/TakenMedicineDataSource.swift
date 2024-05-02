// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model

public protocol TakenMedicineDataSource {
    func insertTakenMedicine(with itemCode: String, at takenTime: Date) -> Completable
    func fetchTakenMedicineList(at filter: Date) -> Single<[MedicineTakenEntity]>
    func fetchMedicineRecode() -> Single<MedicineRecodeEntity?>
}
