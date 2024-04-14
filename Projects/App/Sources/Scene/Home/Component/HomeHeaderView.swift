// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class HomeHeaderView: UIView {

    private let helloLabel = UILabel().then {
        $0.customLabel("안녕하세요! 👋", font: .bodyB1Medium, textColor: .black2)
    }
    private let headerLabel = UIImageView(image: UIImage(named: "HomeHeader"))

    init() {
        super.init(frame: .zero)
        addView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        addSubViews(
            helloLabel,
            headerLabel
        )
    }

    private func setLayout() {
        helloLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(helloLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(headerLabel.snp.bottom)
            $0.trailing.equalTo(headerLabel)
        }
    }
}
