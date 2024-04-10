// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

public protocol FindBookMarkMedicineUseCase {
    var repository: FindBookMarkMedicineRepository { get set }

    func execute(with itemCode: String) -> Single<MedicineInfoEntity?>
}
