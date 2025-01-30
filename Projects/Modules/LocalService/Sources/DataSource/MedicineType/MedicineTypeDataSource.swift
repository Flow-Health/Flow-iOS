// Copyright © 2025 com.flow-health. All rights reserved.

import Foundation
import RxSwift
import Model

public protocol MedicineTypeDataSource {
    func insertMedicineType(with itemCode: String, type medicineType: MedicineTypeEnum) -> Completable
}
