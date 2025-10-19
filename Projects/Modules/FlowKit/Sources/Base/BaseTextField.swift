// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import Core

import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

open class BaseTextField: UITextField {

    open var disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
        addView()
        setAutoLayout()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func attribute() {}
    open func bind() {}
    open func addView() {}
    open func setAutoLayout() {}
}
