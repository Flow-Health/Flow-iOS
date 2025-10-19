// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class SearchButtonView: BaseButton {

    private let mainTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.customLabel("원하는 약\n검색하기", font: .bodyB1Bold, textColor: .black)
    }

    private let sideImageView = UIImageView().then {
        $0.image = FlowKitAsset.glassTiltedRight.image
    }

    override func attribute() {
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = .white
    }

    override func addView() {
        addSubViews(
            mainTitleLabel,
            sideImageView
        )
    }

    override func setAutoLayout() {
        mainTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        sideImageView.snp.makeConstraints {
            $0.size.equalTo(77)
            $0.top.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(12)
        }
        self.snp.makeConstraints {
            $0.height.equalTo(70)
        }
    }
}
