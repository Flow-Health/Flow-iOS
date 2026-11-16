// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class WidgetTutorialButton: BaseButton {
    private let iconContainerView = UIView().then {
        $0.backgroundColor = .blue5
        $0.layer.cornerRadius = 12
        $0.isUserInteractionEnabled = false
    }
    private let iconImageView = UIImageView().then {
        $0.image = .init(systemName: "square.grid.2x2.fill")
        $0.tintColor = .blue1
        $0.contentMode = .scaleAspectFit
    }
    private let labelStack = VStack(spacing: 3).then {
        $0.alignment = .leading
        $0.isUserInteractionEnabled = false
    }
    private let mainTitleLabel = UILabel().then {
        $0.customLabel("위젯으로 더 빠르게 기록하기", font: .bodyB2Bold, textColor: .black)
    }
    private let subTitleLabel = UILabel().then {
        $0.customLabel("홈 화면에 위젯을 추가하는 방법 보기", font: .captionC1Medium, textColor: .black2)
    }
    private let arrowImageView = UIImageView().then {
        $0.image = FlowKitAsset.bannerLeftArrow.image
        $0.tintColor = .black3
    }

    override func attribute() {
        backgroundColor = .white
        layer.cornerRadius = 20
    }

    override func addView() {
        addSubViews(
            iconContainerView,
            labelStack,
            arrowImageView
        )
        iconContainerView.addSubview(iconImageView)
        labelStack.addArrangedSubviews(
            mainTitleLabel,
            subTitleLabel
        )
    }

    override func setAutoLayout() {
        iconContainerView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.center.equalToSuperview()
        }
        labelStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(iconContainerView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(arrowImageView.snp.leading).offset(-12)
        }
        arrowImageView.snp.makeConstraints {
            $0.width.equalTo(7)
            $0.height.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        self.snp.makeConstraints {
            $0.height.equalTo(68)
        }
    }
}
