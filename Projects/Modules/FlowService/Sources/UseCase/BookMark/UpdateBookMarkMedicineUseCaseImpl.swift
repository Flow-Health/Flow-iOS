// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

class UpdateBookMarkMedicineUseCaseImpl: UpdateBookMarkMedicineUseCase {
    var repository: UpdateBookMarkMedicineRepository

    init(repository: UpdateBookMarkMedicineRepository) {
        self.repository = repository
    }
    
    func execute(to entity: MedicineInfoEntity, at itemCode: String) -> Completable {
        repository.updateBookMarkMedicine(to: entity, at: itemCode)
    }
}
