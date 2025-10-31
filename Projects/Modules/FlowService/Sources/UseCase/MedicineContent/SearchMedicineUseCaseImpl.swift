// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

class SearchMedicineUseCaseImpl: SearchMedicineUseCase {
    var repository: SearchMedicineRepository

    init(repository: SearchMedicineRepository) {
        self.repository = repository
    }

    func execute(with name: String, _ pageNumber: Int) -> Single<[MedicineInfoEntity]> {
        repository.searchMedicine(with: name, pageNumber, 10)
    }
}
