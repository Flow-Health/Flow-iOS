// Copyright © 2026 com.flow-health. All rights reserved.

import Foundation

import RxSwift

class DeleteTakenMedicineUseCaseImpl: DeleteTakenMedicineUseCase {
    public var repository: DeleteTakenMedicineRepository

    init(repository: DeleteTakenMedicineRepository) {
        self.repository = repository
    }

    public func execute(rowIDs: [Int64]) -> Completable {
        repository.deleteTakenMedicine(rowIDs: rowIDs)
    }
}
