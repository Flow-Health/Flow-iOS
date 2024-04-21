// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation
import Model

import RxFlow

enum FlowStep: Step {
    case homeIsRequired
    case searchIsRequired
    case bookMarkIsRequired
    case madicineDetailIsRequired(with: MedicineInfoEntity)
}
