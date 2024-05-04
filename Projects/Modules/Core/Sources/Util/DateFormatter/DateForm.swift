// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public enum DateForm {
    /// h:mm a
    case nomal

    /// yyyy-MM-dd
    case fullDate

    /// yyyy-MM-dd h:mm a
    case fullDateAndTime

    /// M월 d일
    case mounthAndDateWithCharacter

    /// yy년 M월 d일
    case fullDateWithCharacter

    var form: String {
        switch self {
        case .nomal: return "h:mm a"
        case .fullDate: return "yyyy-MM-dd"
        case .fullDateAndTime: return "yyyy-MM-dd h:mm a"
        case .mounthAndDateWithCharacter: return "M월 d일"
        case .fullDateWithCharacter: return "yy년 M월 d일"
        }
    }
}
