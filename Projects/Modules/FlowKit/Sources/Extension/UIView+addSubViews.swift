// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

public extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }

    func addSubViews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

