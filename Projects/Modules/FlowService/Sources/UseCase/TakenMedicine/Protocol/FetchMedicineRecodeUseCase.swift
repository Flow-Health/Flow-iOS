// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

public protocol FetchMedicineRecodeUseCase {
    var repository: FetchMedicineRecodeRepository { get set }

    func execute() -> Single<MedicineRecodeEntity?>
}
