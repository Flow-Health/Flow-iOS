// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class EmptyStatusView: BaseView {

    private let iconImageView = UIImageView()

    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .bodyB2Bold
        $0.textAlignment = .center
    }

    private let subTitleLabel = UILabel().then {
        $0.textColor = .black2
        $0.font = .bodyB2Light
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    init(
        icon: UIImage,
        title: String?,
        subTitle: String?
    ) {
        super.init(frame: .zero)
        iconImageView.image = icon
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubViews(
            iconImageView,
            titleLabel,
            subTitleLabel
        )
    }

    override func setAutoLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(subTitleLabel).offset(10)
        }
    }
}
