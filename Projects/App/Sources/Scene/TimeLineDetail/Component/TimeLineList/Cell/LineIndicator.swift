// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class LineIndicator: BaseView {
    private let outCircle = UIView().then {
        $0.backgroundColor = .blue1
        $0.layer.cornerRadius = 7
    }
    private let inCircle = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 3
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .black4
        $0.layer.cornerRadius = 1
    }

    var isLast: Bool {
        set { lineView.isHidden = newValue }
        get { lineView.isHidden }
    }

    override func addView() {
        outCircle.addSubview(inCircle)
        addSubViews(
            outCircle,
            lineView
        )
    }

    override func setAutoLayout() {
        outCircle.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.top.equalToSuperview().inset(2)
            $0.centerX.equalToSuperview()
        }
        inCircle.snp.makeConstraints {
            $0.width.height.equalTo(6)
            $0.center.equalToSuperview()
        }
        lineView.snp.makeConstraints {
            $0.width.equalTo(2)
            $0.centerX.equalTo(outCircle)
            $0.top.equalTo(outCircle.snp.bottom).offset(2)
            $0.bottom.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.width.equalTo(outCircle)
        }
    }
}
