// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class AppInfoButton: BaseButton {
    private let iconImageView = UIImageView().then {
        $0.image = .init(systemName: "info.circle")
        $0.tintColor = .blue1
    }
    private let contentLabel = UILabel().then {
        $0.customLabel("앱 정보", font: .bodyB3Bold, textColor: .blue1)
    }
    private let arrowImageView = UIImageView().then {
        $0.image = FlowKitAsset.bannerLeftArrow.image
        $0.tintColor = .black3
    }

    override func attribute() {
        backgroundColor = .white
        layer.cornerRadius = 20
        setShadow(
            color: .black,
            opacity: 0.05,
            radius: 10,
            offset: .init(width: 0, height: 4)
        )
    }

    override func addView() {
        addSubViews(
            iconImageView,
            contentLabel,
            arrowImageView
        )
    }

    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(6)
        }
        arrowImageView.snp.makeConstraints {
            $0.width.equalTo(7)
            $0.height.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        self.snp.makeConstraints {
            $0.height.equalTo(46)
        }
    }
}
