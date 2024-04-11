// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import SnapKit
import Then

class BookMarkMedicineView: BaseView {

    private let headerButton = HeaderNavigationButton()
    private let medicineVStack = VStack(spacing: 10)

    init(isNavigatAble: Bool = false) {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        backgroundColor = .white
        headerButton.setHeader("자주 먹는 약")
        headerButton.isEnabled = isNavigatAble
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubViews(
            headerButton,
            medicineVStack
        )
    }

    override func setLayout() {
        headerButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(24)
        }
        medicineVStack.snp.makeConstraints {
            $0.top.equalTo(headerButton.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(medicineVStack).offset(20)
        }
    }
}

extension BookMarkMedicineView {
    func addBookMarkMedicine(_ entity: [MedicineInfoEntity]) {
        let colorSet: [UIColor] = [.blue1, .blue2, .blue3, .blue4]
        let bookMarkCells = entity.enumerated().map {
            return BookMarkContentCell(
                guardLineColor: colorSet[$0.offset % 4],
                companyName: $0.element.companyName,
                medicineName: $0.element.medicineName
            )
        }
        medicineVStack.addArrangedSubviews(bookMarkCells)
        self.setLayout()
    }
}