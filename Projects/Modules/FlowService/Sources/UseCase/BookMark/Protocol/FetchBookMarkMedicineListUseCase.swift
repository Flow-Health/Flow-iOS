// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

import Model
import RxSwift

public protocol FetchBookMarkMedicineListUseCase {
    var repository: FetchBookMarkMedicineListRepository { get set }

    func execute() -> Single<[MedicineInfoEntity]>
}
