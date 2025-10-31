// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import Then
import Kingfisher

class OcrMedicineSelectionCell: UITableViewCell {
    static let identifier = "ocrMedicineSelectionCell"

    private let medicineImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }

    private let medicineNameLabel = UILabel().then {
        $0.customLabel(font: .bodyB2SemiBold, textColor: .blue1)
        $0.textAlignment = .left
    }

    private let companyNameLabel = UILabel().then {
        $0.customLabel(font: .captionC1SemiBold, textColor: .black2)
        $0.textAlignment = .left
    }

    private let alreadyAddLabel = UILabel().then {
        $0.customLabel("이미 추가됨", font: .captionC2SemiBold, textColor: .blue1)
        $0.textAlignment = .right
        $0.isHidden = true
    }

    private let selectionIndicator = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .black4
    }

    private let selectionCircle = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.backgroundColor = .blue1
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addView()
        setAutoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        addSubViews(
            medicineImageView,
            medicineNameLabel,
            companyNameLabel,
            selectionIndicator,
            alreadyAddLabel
        )
        selectionIndicator.addSubview(selectionCircle)
    }

    private func setAutoLayout() {
        medicineImageView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }

        medicineNameLabel.snp.makeConstraints {
            $0.top.equalTo(medicineImageView).offset(14)
            $0.leading.equalTo(medicineImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(selectionCircle.snp.leading).offset(-10)
        }

        companyNameLabel.snp.makeConstraints {
            $0.top.equalTo(medicineNameLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(medicineNameLabel)
        }

        selectionIndicator.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
        }

        selectionCircle.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.center.equalToSuperview()
        }

        alreadyAddLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(8)
        }
    }
}

extension OcrMedicineSelectionCell {
    func setup(_ entity: MedicineInfoEntity, isSelect: Bool, isAlreadyAdd: Bool) {
        medicineImageView.kf.setImage(
            with: URL(string: entity.imageURL),
            placeholder: FlowKitAsset.defaultImage.image
        )
        medicineNameLabel.text = entity.medicineName
        companyNameLabel.text = entity.companyName

        selectionCircle.backgroundColor = isSelect ? .blue1 : .white

        [
            medicineImageView,
            medicineNameLabel,
            companyNameLabel
        ].forEach {
            $0.alpha = isAlreadyAdd ? 0.5 : 1
        }

        selectionIndicator.isHidden = isAlreadyAdd
        alreadyAddLabel.isHidden = !isAlreadyAdd
        self.isUserInteractionEnabled = !isAlreadyAdd
    }
}
