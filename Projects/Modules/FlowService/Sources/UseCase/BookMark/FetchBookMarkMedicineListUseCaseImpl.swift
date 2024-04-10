// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

class FetchBookMarkMedicineListUseCaseImpl: FetchBookMarkMedicineListUseCase {
    var repository: FetchBookMarkMedicineListRepository

    init(repository: FetchBookMarkMedicineListRepository) {
        self.repository = repository
    }

    public func execute() -> Single<[MedicineInfoEntity]> {
        return repository.fetchBookMarkMedicineList()
    }
}
