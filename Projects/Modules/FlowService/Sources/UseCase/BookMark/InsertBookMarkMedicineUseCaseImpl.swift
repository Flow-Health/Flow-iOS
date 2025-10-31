// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

class InsertBookMarkMedicineUseCaseImpl: InsertBookMarkMedicineUseCase {
    var repository: InsertBookMarkMedicineRepository

    init(repository: InsertBookMarkMedicineRepository) {
        self.repository = repository
    }
    
    func execute(with entity: MedicineInfoEntity) -> Completable {
        repository.insertBookMarkMedicine(with: entity)
    }

    func execute(with entities: [MedicineInfoEntity]) -> Completable {
        let observalbes = entities.map { entity in
            repository.insertBookMarkMedicine(with: entity)
        }

        return Completable.zip(observalbes)
    }
}
