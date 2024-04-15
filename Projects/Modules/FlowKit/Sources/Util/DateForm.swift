// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public enum DateForm {
    case nomal, fullDate

    var form: String {
        switch self {
        case .nomal: return "h:mm a"
        case .fullDate: return "yyyy-MM-dd"
        }
    }
}
