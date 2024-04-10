// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

class InsertBookMarkMedicineUseCaseImpl: InsertBookMarkMedicineUseCase {
    var repository: InsertBookMarkMedicineRepository

    init(repository: InsertBookMarkMedicineRepository) {
        self.repository = repository
    }
    
    public func execute(with entity: MedicineInfoEntity) -> Completable {
        repository.insertBookMarkMedicine(with: entity)
    }
}
