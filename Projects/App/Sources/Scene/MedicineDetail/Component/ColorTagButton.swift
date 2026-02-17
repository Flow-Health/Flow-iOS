// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class ColorTagButton: UIBarButtonItem {
    var tagColor: UIColor? {
        set {
            if let color = newValue {
                image = UIImage(systemName: "tag.fill")
                tintColor = color
            } else {
                image = UIImage(systemName: "tag")
                tintColor = .black4
            }
        }
        get { tintColor }
    }

    override init() {
        super.init()
        guard #available(iOS 26.0, *) else {
            // iOS 26.0 버전 이하
            imageInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
            return
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
