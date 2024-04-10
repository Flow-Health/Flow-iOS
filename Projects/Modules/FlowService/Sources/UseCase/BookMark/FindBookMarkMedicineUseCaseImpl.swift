// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

class FindBookMarkMedicineUseCaseImpl: FindBookMarkMedicineUseCase {
    var repository: FindBookMarkMedicineRepository

    init(repository: FindBookMarkMedicineRepository) {
        self.repository = repository
    }

    public func execute(with itemCode: String) -> Single<MedicineInfoEntity?> {
        repository.findBookMarkMedicine(with: itemCode)
    }
}
