// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

public protocol SearchMedicineUseCase {
    var repository: SearchMedicineRepository { get set }

    func execute(with name: String, _ pageNumber: Int) -> Single<[MedicineInfoEntity]>
}
