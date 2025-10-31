// Copyright © 2025 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class ImageRegisterStepView: BaseView {

    private let headerView = RegisterHeaderView(
        description: "마지막 단계입니다!",
        title: "약의 이미지를 선택해주세요."
    )

    let imagePicker = FlowImagePicker()

    let addMedicineButton = FlowNextButton(title: "약 추가하기")

    override func attribute() {
        backgroundColor = .white
    }

    override func addView() {
        addSubViews(
            headerView,
            imagePicker,
            addMedicineButton
        )
    }

    override func setAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(22)
        }

        imagePicker.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }

        addMedicineButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }

    override func setAutoLayoutAfterLayoutSubviews() {
        addMedicineButton.snp.updateConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
                .inset(safeAreaInsets.bottom > 0 ? 0 : 10)
        }
    }
}
