// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class AppInfoTableViewCell: UITableViewCell {
    static let identifier = "AppInfoTableViewCell"

    private let titleLable = UILabel().then {
        $0.customLabel(font: .bodyB3Medium, textColor: .black)
    }
    private let arrowImageView = UIImageView().then {
        $0.image = FlowKitAsset.bannerLeftArrow.image
        $0.tintColor = .black3
    }

    override func layoutSubviews() {
        addView()
        setLayout()
    }

    private func addView() {
        addSubViews(
            titleLable,
            arrowImageView
        )
    }

    private func setLayout() {
        titleLable.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
        }
    }
}

extension AppInfoTableViewCell {
    func setup(title: String?) {
        titleLable.text = title
    }
}
