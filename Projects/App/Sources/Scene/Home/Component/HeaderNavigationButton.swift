// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class HeaderNavigationButton: BaseButton {

    private let buttonHStack = HStack().then {
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.isUserInteractionEnabled = false
    }

    private let headerLabel = UILabel().then {
        $0.font = .headerH3Bold
        $0.textColor = .black
    }

    private let leftArrowImageView = UIImageView().then {
        $0.image = FlowKitAsset.bannerLeftArrow.image
        $0.tintColor = .black3
    }

    override func addView() {
        addSubview(buttonHStack)
        buttonHStack.addArrangedSubviews(
            headerLabel,
            leftArrowImageView
        )
    }

    override func setAutoLayout() {
        buttonHStack.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(buttonHStack)
        }
    }

    override var isEnabled: Bool {
        didSet { leftArrowImageView.isHidden = !isEnabled }
    }
}

extension HeaderNavigationButton {
    func setHeader(_ header: String?) {
        self.headerLabel.text = header
    }
}
