// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public enum DateForm {
    /// h:mm a
    case nomal

    /// h:mm a
    case fullDate

    /// yyyy-MM-dd h:mm a
    case fullDateAndTime

    var form: String {
        switch self {
        case .nomal: return "h:mm a"
        case .fullDate: return "yyyy-MM-dd"
        case .fullDateAndTime: return "yyyy-MM-dd h:mm a"
        }
    }
}
