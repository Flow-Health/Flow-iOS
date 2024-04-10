// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

public protocol BookMarkMedicineDataSource {
    func insertBookMarkMedicine(with entity: MedicineInfoEntity) -> Completable
    func deleteBookMarkMedicine(with itemCode: String) -> Completable
    func fetchBookMarkMedicineList() -> Single<[MedicineInfoEntity]>
    func findBookMarkMedicine(with itemCode: String) -> Single<MedicineInfoEntity?>
}
