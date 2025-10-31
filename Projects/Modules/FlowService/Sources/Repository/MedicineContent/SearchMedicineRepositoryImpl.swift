// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model
import RemoteService

import RxSwift

class SearchMedicineRepositoryImpl: SearchMedicineRepository {
    var nomalMedicinedataSource: MedicineContentDataSource
    var prescriptionMedicinedataSource: PrescriptionMedicineDataSource

    init(
        nomalMedicinedataSource: MedicineContentDataSource,
        prescriptionMedicinedataSource: PrescriptionMedicineDataSource
    ) {
        self.nomalMedicinedataSource = nomalMedicinedataSource
        self.prescriptionMedicinedataSource = prescriptionMedicinedataSource
    }

    func searchMedicine(with name: String, _ pageNumber: Int, _ numOfRows: Int) -> Single<[MedicineInfoEntity]> {
        let nomalMedicineSearch = nomalMedicinedataSource.searchMedicine(with: name, pageNumber, numOfRows)
            .map { $0.map { $0.toDomain() } }
            .asObservable()

        let prescriptionMedicineSearch = prescriptionMedicinedataSource.searchPrescriptionMedicine(with: name, pageNumber, numOfRows)
            .map { $0.map { $0.toDomain() }
            .filter { $0.medicineType == .PRESCRIPTION } }
            .asObservable()

        return Observable.combineLatest(nomalMedicineSearch, prescriptionMedicineSearch) {
            ($0 + $1).sorted { $0.medicineName > $1.medicineName }
        }.asSingle()
    }
}
