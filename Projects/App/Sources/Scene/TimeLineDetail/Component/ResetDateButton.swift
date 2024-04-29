// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit

class ResetDateButton: BaseButton {

    private let customTitleLabel = UILabel().then {
        $0.customLabel(font: .captionC1SemiBold, textColor: .blue1)
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .blue5
        titleLabel?.font = .captionC1SemiBold
        setTitle("오늘로 돌아가기", for: .normal)
        customTitleLabel.text = title(for: .normal)
        layer.cornerRadius = 5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubview(customTitleLabel)
    }

    override func setLayout() {
        customTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.width.equalTo(92)
        }
    }
}
