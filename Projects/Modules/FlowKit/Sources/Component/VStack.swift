// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

public class VStack: UIStackView {

    public init(spacing: CGFloat = 0) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = spacing
        self.backgroundColor = .clear
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
