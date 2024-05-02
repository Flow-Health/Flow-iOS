// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Core

import SnapKit
import Then

open class BaseView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        addView()
        setLayout()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func bind() {}
    open func addView() {}
    open func setLayout() {}
}
