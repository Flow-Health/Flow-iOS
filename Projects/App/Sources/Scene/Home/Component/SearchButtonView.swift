// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class SearchButtonView: BaseButton {

    private let subTitleLabel = UILabel().then {
        $0.customLabel("약의 정보가 궁금하다면?", font: .captionC1SemiBold, textColor: .black2)
    }

    private let mainTitleLabel = UILabel().then {
        $0.customLabel("여기를 눌러 검색하세요!", font: .bodyB1Bold, textColor: .blue1)
    }

    private let leftArrowImageView = UIImageView().then {
        $0.image = FlowKitAsset.bannerLeftArrow.image
        $0.tintColor = .black3
    }

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        backgroundColor = .white
        setShadow(
            color: .black,
            opacity: 0.05,
            radius: 10,
            offset: .init(width: 0, height: 4)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubViews(
            subTitleLabel,
            mainTitleLabel,
            leftArrowImageView
        )
    }

    override func setLayout() {
        subTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
        }
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(1)
            $0.leading.equalTo(subTitleLabel)
        }
        leftArrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(7)
            $0.height.equalTo(12)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(mainTitleLabel).offset(18)
        }
    }
}
