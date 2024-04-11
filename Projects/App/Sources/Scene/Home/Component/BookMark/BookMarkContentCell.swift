// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class BookMarkContentCell: BaseView {
    private let guardLineView = UIView().then {
        $0.layer.cornerRadius = 2
    }

    private let companyNameLabel = UILabel().then {
        $0.font = .captionC2SemiBold
        $0.textColor = .black2
    }

    private let medicineNameLabel = UILabel().then {
        $0.font = .bodyB2SemiBold
        $0.textColor = .blue1
    }

    private let lableVStack = VStack(spacing: 3)

    init(
        guardLineColor: UIColor,
        companyName: String,
        medicineName: String
    ) {
        super.init(frame: .zero)
        guardLineView.backgroundColor = guardLineColor
        companyNameLabel.text = companyName
        medicineNameLabel.text = medicineName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubViews(
            guardLineView,
            lableVStack
        )
        lableVStack.addArrangedSubviews(
            companyNameLabel,
            medicineNameLabel
        )
    }

    override func setLayout() {
        guardLineView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(4)
        }
        lableVStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(guardLineView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(lableVStack).offset(5)
        }
    }
}
