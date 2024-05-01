// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class TimeLineHeaderLabel: UILabel {
    init() {
        super.init(frame: .zero)
        font = .headerH2SemiBold
        textColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TimeLineHeaderLabel {
    func setCountOfMedicine(with number: Int) {
        guard number != 0 else {
            text = "복용한 약이 없어요"
            return
        }
        let fullText = "\(number)개의 약을 복용했어요"
        let attributeString = NSMutableAttributedString(string: fullText)
        attributeString.addAttribute(.foregroundColor, value: UIColor.blue1, range: (fullText as NSString).range(of: "\(number)개"))
        attributeString.addAttribute(.font, value: UIFont.headerH2Bold, range: (fullText as NSString).range(of: "\(number)개"))
        self.attributedText = attributeString
    }
}
