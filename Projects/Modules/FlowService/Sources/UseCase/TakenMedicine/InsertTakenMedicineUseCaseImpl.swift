// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import LocalService

import RxSwift

class InsertTakenMedicineUseCaseImpl: InsertTakenMedicineUseCase {
    public var repository: InsertTakenMedicineRepository

    init(repository: InsertTakenMedicineRepository) {
        self.repository = repository
    }

    public func execute(with itemCode: String, at time: Date) -> Completable {
        repository.insertTakenMedicine(with: itemCode, at: time)
    }
}
