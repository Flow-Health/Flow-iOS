// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import Kingfisher
import SnapKit
import Then

class TimeLineListCell: UICollectionViewCell {

    private let lineIndicator = LineIndicator()
    private let labelStack = VStack(spacing: 5)
    private let tekenTimeLabel = UILabel().then {
        $0.customLabel(font: .bodyB1SemiBold, textColor: .black)
    }
    private let medicineNameLabel = UILabel().then {
        $0.customLabel(font: .bodyB2SemiBold, textColor: .blue1)
        $0.numberOfLines = 0
    }
    private let companyNameLabel = UILabel().then {
        $0.customLabel(font: .captionC1SemiBold, textColor: .black2)
    }
    private let medicineImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        medicineImageView.kf.cancelDownloadTask()
        medicineImageView.image = FlowKitAsset.defaultImage.image
    }

    private func addView() {
        labelStack.addArrangedSubviews(
            tekenTimeLabel,
            medicineNameLabel,
            companyNameLabel
        )
        contentView.addSubViews(
            lineIndicator,
            labelStack,
            medicineImageView
        )
    }

    private func setAutoLayout() {
        labelStack.setCustomSpacing(3, after: medicineNameLabel)
        lineIndicator.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
        }
        labelStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(lineIndicator.snp.trailing).offset(20)
            $0.trailing.equalTo(medicineImageView.snp.leading).offset(-15)
            $0.bottom.equalToSuperview().inset(32)
        }
        medicineImageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }
    }
}

extension TimeLineListCell {
    func configCell(
        isLast: Bool,
        takenTime: String?,
        medicineName: String?,
        companyName: String?,
        imageURL: String
    ) {
        lineIndicator.isLast = isLast
        tekenTimeLabel.text = takenTime
        medicineNameLabel.text = medicineName
        companyNameLabel.text = companyName
        medicineImageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: FlowKitAsset.defaultImage.image
        )
    }
}
