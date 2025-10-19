// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import SnapKit
import Then

class TimeLineCell: BaseView {
    private let labelVSatck = VStack(spacing: 4)
    private let timeLable = UILabel().then {
        $0.font = .bodyB3SemiBold
        $0.textColor = .black
    }
    private let medicineNameLabel = UILabel().then {
        $0.font = .bodyB3SemiBold
        $0.textColor = .blue1
    }
    private let pointDotView = PointLineView()

    init(
        isFirst: Bool = false,
        isLast: Bool = false,
        time: String?,
        medicineName: String?
    ) {
        super.init(frame: .zero)
        pointDotView.topLine.isHidden = isFirst
        pointDotView.bottomLine.isHidden = isLast
        timeLable.text = time
        medicineNameLabel.text = medicineName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubViews(
            labelVSatck,
            pointDotView
        )
        labelVSatck.addArrangedSubviews(
            timeLable,
            medicineNameLabel
        )
    }

    override func setAutoLayout() {
        pointDotView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(18)
        }
        labelVSatck.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.leading.equalTo(pointDotView.snp.trailing).offset(13)
            $0.trailing.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(labelVSatck).offset(11)
        }
    }
}
