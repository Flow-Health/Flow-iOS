// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import SnapKit
import Then

public class VScrollView: UIScrollView {
    public let contentView = UIView().then { $0.backgroundColor = .clear }

    public init(
        showsVerticalScrollIndicator: Bool = false
    ) {
        super.init(frame: .zero)
        self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        addSubview(contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
