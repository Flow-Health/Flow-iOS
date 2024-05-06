// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class BookMarkToggleButton: UIBarButtonItem {
    var isBookMarked: Bool = false {
        didSet { image = UIImage(systemName: "bookmark\(isBookMarked ? ".fill" : "")") }
    }

    override init() {
        super.init()
        tintColor = .blue1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
