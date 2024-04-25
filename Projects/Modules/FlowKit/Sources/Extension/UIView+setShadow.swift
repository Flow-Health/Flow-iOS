// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

public extension UIView {
    func setShadow(
        color: UIColor?,
        opacity: Float = 1.0,
        radius: CGFloat,
        offset: CGSize
    ) {
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }
}
