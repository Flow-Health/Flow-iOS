// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService
import Model

import RxSwift

public class FetchTakenMedicineListUseCaseImpl: FetchTakenMedicineListUseCase {
    public var repository: FetchTakenMedicineListRepository

    init(repository: FetchTakenMedicineListRepository) {
        self.repository = repository
    }

    public func execute() -> Single<[MedicineTakenEntity]> {
        repository.fetchTakenMedicineList()
    }
}
