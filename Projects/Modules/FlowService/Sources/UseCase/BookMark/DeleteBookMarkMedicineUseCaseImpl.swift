// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

class DeleteBookMarkMedicineUseCaseImpl: DeleteBookMarkMedicineUseCase {
    var repository: DeleteBookMarkMedicineRepository

    init(repository: DeleteBookMarkMedicineRepository) {
        self.repository = repository
    }

    func execute(with itemCode: String) -> Completable {
        repository.deleteBookMarkMedicine(with: itemCode)
    }
}
