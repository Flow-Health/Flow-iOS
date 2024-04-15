// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

open class HStack: UIStackView {

    public init(spacing: CGFloat = 0) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.spacing = spacing
        self.backgroundColor = .clear
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
