// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public struct MedicineTakenEntity {
    public let takenTime: Date
    public let medicineInfo: MedicineInfoEntity

    public init(takenTime: Date, medicineInfo: MedicineInfoEntity) {
        self.takenTime = takenTime
        self.medicineInfo = medicineInfo
    }
}
