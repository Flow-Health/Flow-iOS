// Copyright © 2024 com.flow-health. All rights reserved.

// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService
import Model

import RxSwift

class FetchMedicineRecodeUseCaseImpl: FetchMedicineRecodeUseCase {
    public var repository: FetchMedicineRecodeRepository

    init(repository: FetchMedicineRecodeRepository) {
        self.repository = repository
    }

    public func execute() -> Single<MedicineRecodeEntity?> {
        repository.fetchMedicineRecode()
    }
}
