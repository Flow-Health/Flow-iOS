// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Core
import RxSwift

import SnapKit
import Then

open class BaseView: UIView {

    public let disposeBag = DisposeBag()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        bind()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        addView()
        setLayout()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func attribute() {}
    open func bind() {}
    open func addView() {}
    open func setLayout() {}
}
