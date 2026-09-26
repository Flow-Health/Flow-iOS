// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import Kingfisher
import SnapKit
import Then

class TimeLineSettingCell: UICollectionViewCell {

    private let checkImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black4
        $0.image = UIImage(systemName: "circle")
    }
    private let medicineImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    private let labelStack = VStack(spacing: 3)
    private let takenTimeLabel = UILabel().then {
        $0.customLabel(font: .captionC1SemiBold, textColor: .black2)
    }
    private let medicineNameLabel = UILabel().then {
        $0.customLabel(font: .bodyB2SemiBold, textColor: .blue1)
        $0.numberOfLines = 0
    }
    private let companyNameLabel = UILabel().then {
        $0.customLabel(font: .captionC1SemiBold, textColor: .black2)
    }
    private let separatorView = UIView().then {
        $0.backgroundColor = .black5
    }

    override var isSelected: Bool {
        didSet { updateSelectionStyle() }
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
            takenTimeLabel,
            medicineNameLabel,
            companyNameLabel
        )
        contentView.addSubViews(
            checkImageView,
            medicineImageView,
            labelStack,
            separatorView
        )
    }

    private func setAutoLayout() {
        checkImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        medicineImageView.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.leading.equalTo(checkImageView.snp.trailing).offset(14)
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(14)
        }
        labelStack.snp.makeConstraints {
            $0.leading.equalTo(medicineImageView.snp.trailing).offset(14)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.top.greaterThanOrEqualToSuperview().inset(14)
        }
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func updateSelectionStyle() {
        checkImageView.image = UIImage(systemName: isSelected ? "checkmark.circle.fill" : "circle")
        checkImageView.tintColor = isSelected ? .blue1 : .black4
    }
}

extension TimeLineSettingCell {
    func configCell(
        takenTime: String?,
        medicineName: String?,
        companyName: String?,
        imageURL: String
    ) {
        takenTimeLabel.text = takenTime
        medicineNameLabel.text = medicineName
        companyNameLabel.text = companyName
        medicineImageView.kf.setImage(
            with: URL(string: imageURL),
            placeholder: FlowKitAsset.defaultImage.image
        )
    }
}
