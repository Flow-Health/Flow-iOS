// Copyright © 2025 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

class SearchMedicineWithOcrUseCaseImpl: SearchMedicineWithOcrUseCase {
    var repository: SearchMedicineRepository

    init(repository: SearchMedicineRepository) {
        self.repository = repository
    }

    func execute(with ocrTextList: [String]) -> Single<[MedicineInfoEntity]> {

        let observables = ocrTextList.map {
            repository.searchMedicine(with: $0, 1, 5)
        }

        return Single.zip(observables).map { $0.flatMap { $0 } }
    }
}
