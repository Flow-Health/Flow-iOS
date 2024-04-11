// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class HomeHeaderView: BaseView {

    private let helloLabel = UILabel().then {
        $0.customLabel("안녕하세요! 👋", font: .bodyB1Medium, textColor: .black2)
    }
    private let headerLabel = UIImageView(image: UIImage(named: "HomeHeader"))

    override func addView() {
        addSubViews(
            helloLabel,
            headerLabel
        )
    }

    override func setLayout() {
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
