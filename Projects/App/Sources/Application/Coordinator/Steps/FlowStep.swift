// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxFlow

enum FlowStep: Step {
    case homeIsRequired
    case searchIsRequired
    case receiptOcrIsRequired
    case bookMarkIsRequired
    case madicineDetailIsRequired(with: MedicineInfoEntity)
    case timeLineDetailIsRequired
    case appInfoIsRequired
    case createMyMedicineIsRequired
}
