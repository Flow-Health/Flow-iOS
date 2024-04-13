// Copyright © 2024 com.flow-health. All rights reserved.

import Foundation

public extension Date {
    func toString(_ dateForm: DateForm) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateForm.form
        return dateFormatter.string(from: self)
    }
}
