// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import Kingfisher
import RxSwift
import RxCocoa
import Then

class SearchResultTableCell: UITableViewCell {
    static let identifier = "SearchResultTableCell"

    private let medicineImageView = UIImageView().then {
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    private let medicineNameLabel = UILabel().then {
        $0.font = .bodyB2SemiBold
        $0.textColor = .blue1
    }
    private let companyNameLabel = UILabel().then {
        $0.font = .captionC1SemiBold
        $0.textColor = .black2
    }
    private let updateAtLabel = PaddingLableView()
    private let medicineTypeLabel = PaddingLableView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        addView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        addSubViews(
            medicineImageView,
            medicineNameLabel,
            companyNameLabel,
            updateAtLabel,
            medicineTypeLabel
        )
    }

    private func setLayout() {
        medicineImageView.snp.makeConstraints {
            $0.width.equalTo(125)
            $0.top.bottom.leading.equalToSuperview().inset(20)
        }
        medicineNameLabel.snp.makeConstraints {
            $0.leading.equalTo(medicineImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(medicineImageView).offset(8)
        }
        companyNameLabel.snp.makeConstraints {
            $0.top.equalTo(medicineNameLabel.snp.bottom).offset(2)
            $0.leading.trailing.equalTo(medicineNameLabel)
        }
        updateAtLabel.snp.makeConstraints {
            $0.top.equalTo(companyNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(companyNameLabel)
        }
        medicineTypeLabel.snp.makeConstraints {
            $0.top.equalTo(updateAtLabel)
            $0.leading.equalTo(updateAtLabel.snp.trailing).offset(5)
        }
    }
}

extension SearchResultTableCell {
    func setup(_ entity: MedicineInfoEntity) {
        medicineImageView.kf.setImage(
            with: URL(string: entity.imageURL),
            placeholder: FlowKitAsset.defaultImage.image
        )
        medicineNameLabel.text = entity.medicineName
        companyNameLabel.text = entity.companyName
        updateAtLabel.contentText = entity.updateDate
        medicineTypeLabel.contentText = entity.medicineType.toString
        medicineTypeLabel.setTagType(tagType: entity.medicineType == .NOMAL ? .Common : .Primary)
    }
}
