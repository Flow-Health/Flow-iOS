// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ view: UIView...) {
        view.forEach(self.addArrangedSubview(_:))
    }

    func addArrangedSubviews(_ view: [UIView]) {
        view.forEach(self.addArrangedSubview(_:))
    }
}
