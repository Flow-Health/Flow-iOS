// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

public extension UILabel {
    func customLabel(
        _ text: String? = nil,
        font: UIFont,
        textColor: UIColor = .black
    ) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
