// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public enum MedicineTypeEnum: String {
    /// 일반약
    case NOMAL = "일반의약품"

    /// 전문약
    case PRESCRIPTION = "전문의약품"

    /// 나만의 약
    case CUSTOM = "나만의 약"
    
    public var toString : String {
        switch self {
        case .NOMAL: return "일반의약품"
        case .PRESCRIPTION: return "전문의약품"
        case .CUSTOM: return "나만의 약"
        }
    }
}
