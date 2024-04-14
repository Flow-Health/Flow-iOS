// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Core

import SnapKit
import Then

open class BaseView: UIView {

    override open func layoutSubviews() {
        addView()
        setLayout()
    }

    open func addView() {}
    open func setLayout() {}
}
