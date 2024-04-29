// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Core

import SnapKit
import Then

open class BaseView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        addView()
        setLayout()
    }

    open func bind() {}
    open func addView() {}
    open func setLayout() {}
}
