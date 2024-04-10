// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

public protocol InsertTakenMedicineUseCase {
    var repository: InsertTakenMedicineRepository { get set }

    func execute(with itemCode: String, at time: Date) -> Completable
}
