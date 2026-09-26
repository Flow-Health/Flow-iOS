// Copyright © 2026 com.flow-health. All rights reserved.

import Foundation

import RxSwift

public protocol DeleteTakenMedicineUseCase {
    var repository: DeleteTakenMedicineRepository { get set }

    func execute(rowIDs: [Int64]) -> Completable
}
