// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public struct MedicineRecodeEntity {
    public let lastTakenTime: Date
    public let recentMedicineNameList: [(name: String, id: String)]

    public init(lastTakenTime: Date, recentMedicineNameList: [(name: String, id: String)]) {
        self.lastTakenTime = lastTakenTime
        self.recentMedicineNameList = recentMedicineNameList
    }
}
