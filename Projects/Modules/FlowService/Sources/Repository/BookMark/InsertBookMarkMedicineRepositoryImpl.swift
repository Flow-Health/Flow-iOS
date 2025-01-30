// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import RxSwift
import Model
import LocalService

class InsertBookMarkMedicineRepositoryImpl: InsertBookMarkMedicineRepository {
    var bookMarkMedicineDataSource: BookMarkMedicineDataSource
    var medicineTypeDataSource: MedicineTypeDataSource

    init(bookMarkMedicineDataSource: BookMarkMedicineDataSource, medicineTypeDataSource: MedicineTypeDataSource) {
        self.bookMarkMedicineDataSource = bookMarkMedicineDataSource
        self.medicineTypeDataSource = medicineTypeDataSource
    }

    func insertBookMarkMedicine(with entity: MedicineInfoEntity) -> Completable {
        let bookmakrObservable = bookMarkMedicineDataSource.insertBookMarkMedicine(with: entity).asObservable()
        let medicineTypeObservable = medicineTypeDataSource.insertMedicineType(with: entity.itemCode, type: entity.medicineType).asObservable()
        let observable = Observable.combineLatest(bookmakrObservable, medicineTypeObservable)

        return Completable.create { Completable in
            Completable(.completed)
            observable
                .subscribe(onError: { error in
                    Completable(.error(error))
                }, onCompleted: {
                    Completable(.completed)
                })
                .disposed(by: DisposeBag())
            
            return Disposables.create()
        }
    }
}
