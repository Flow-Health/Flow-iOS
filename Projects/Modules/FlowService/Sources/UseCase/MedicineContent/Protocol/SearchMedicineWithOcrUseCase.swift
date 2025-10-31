// Copyright © 2025 com.flow-health. All rights reserved.

import Foundation
import Model

import RxSwift

public protocol SearchMedicineWithOcrUseCase {
    var repository: SearchMedicineRepository { get set }

    func execute(with ocrTextList: [String]) -> Single<[MedicineInfoEntity]>
}
