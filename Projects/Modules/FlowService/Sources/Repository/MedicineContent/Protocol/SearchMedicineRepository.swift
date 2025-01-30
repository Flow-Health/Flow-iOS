// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model
import RemoteService

import RxSwift

public protocol SearchMedicineRepository {
    var nomalMedicinedataSource: MedicineContentDataSource { get }
    var prescriptionMedicinedataSource: PrescriptionMedicineDataSource { get }

    func searchMedicine(with name: String) -> Single<[MedicineInfoEntity]>
}
