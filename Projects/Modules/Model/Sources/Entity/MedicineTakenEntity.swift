// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public struct MedicineTakenEntity {
    public let rowID: Int64
    public let takenTime: Date
    public let medicineInfo: MedicineInfoEntity

    public init(
        rowID: Int64,
        takenTime: Date,
        medicineInfo: MedicineInfoEntity
    ) {
        self.rowID = rowID
        self.takenTime = takenTime
        self.medicineInfo = medicineInfo
    }
}
