// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import SnapKit
import Then

class BookMarkMedicineView: BaseView {

    let headerButton = HeaderNavigationButton().then {
        $0.isUserInteractionEnabled = false
    }

    private let medicineVStack = VStack(spacing: 10)
    private let bookMarkEmptyView = EmptyStatusView(
        icon: FlowKitAsset.emptyBoxWithCloud.image,
        title: "등록된 약이 없습니다",
        subTitle: "약을 검색하여 자주 먹는\n약을 등록해보세요"
    )

    init(isNavigatAble: Bool = true) {
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

    override func setAutoLayout() {
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
        let subViews = medicineVStack.subviews
        subViews.forEach(medicineVStack.removeArrangedSubview(_:))
        subViews.forEach { $0.removeFromSuperview() }

        guard !entity.isEmpty else {
            medicineVStack.addArrangedSubview(bookMarkEmptyView)
            return
        }

        let colorSet: [UIColor] = [.blue1, .blue2, .blue3, .blue4]
        let bookMarkCells = entity.enumerated().map {
            let cell = BookMarkContentCell(
                guardLineColor: colorSet[$0.offset % 4],
                companyName: $0.element.companyName,
                medicineName: $0.element.medicineName
            )
            cell.alpha = 0
            return cell
        }
        self.medicineVStack.addArrangedSubviews(bookMarkCells)
        self.layoutIfNeeded()

        bookMarkCells.forEach { view in
            view.transform = .init(translationX: 0, y: -5)
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 1
                view.transform = .identity
            })
        }
    }
}
