// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

public protocol FetchTakenMedicineListUseCase {
    var repository: FetchTakenMedicineListRepository { get set }

    func execute() -> Single<[MedicineTakenEntity]>
}
