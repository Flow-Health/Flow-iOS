// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class PointLineView: BaseView {
    private let inDot = UIView().then {
        $0.layer.cornerRadius = 2
        $0.backgroundColor = .white
    }
    private let outDot = UIView().then {
        $0.layer.cornerRadius = 6
        $0.backgroundColor = .blue1
    }
    let topLine = UIView().then {
        $0.backgroundColor = .black4
    }
    let bottomLine = UIView().then {
        $0.backgroundColor = .black4
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        outDot.addSubview(inDot)
        addSubViews(
            topLine,
            bottomLine,
            outDot
        )
    }

    override func setLayout() {
        inDot.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(4)
        }
        outDot.snp.makeConstraints {
            $0.width.height.equalTo(12)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
        }
        topLine.snp.makeConstraints {
            $0.width.equalTo(2)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(outDot.snp.centerY)
            $0.centerX.equalToSuperview()
        }
        bottomLine.snp.makeConstraints {
            $0.width.equalTo(2)
            $0.top.equalTo(outDot.snp.centerY)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.width.equalTo(outDot)
        }
    }
}
