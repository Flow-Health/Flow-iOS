// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import SnapKit
import Then

class TimeLineDetailListView: BaseView {
    private let timeLineVStack = VStack()
    private let timeLineEmptyView = EmptyStatusView(
        icon: FlowKitAsset.pageWithCloud.image,
        title: "기록된 정보가 없습니다",
        subTitle: "복용한 약을 기록하여\n타임라인을 만들어 보세요"
    )

    override func addView() {
        addSubview(timeLineVStack)
    }

    override func setAutoLayout() {
        timeLineVStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(timeLineVStack)
        }
    }
}

extension TimeLineDetailListView {
    func setTimeLineList(with entity: [MedicineTakenEntity]) {
        let subViews = timeLineVStack.subviews
        subViews.forEach(timeLineVStack.removeArrangedSubview(_:))
        subViews.forEach { $0.removeFromSuperview() }

        guard !entity.isEmpty else {
            timeLineVStack.addArrangedSubview(timeLineEmptyView)
            return
        }

        let timeLineCells = entity.enumerated().map {
            let cell = TimeLineListCell(
                isLast: $0.offset == entity.count - 1,
                takenTime: $0.element.takenTime.toString(.nomal),
                medicineName: $0.element.medicineInfo.medicineName,
                companyName: $0.element.medicineInfo.companyName,
                imageURL: $0.element.medicineInfo.imageURL
            )
            cell.alpha = 0
            return cell
        }
        self.timeLineVStack.addArrangedSubviews(timeLineCells)
        self.layoutIfNeeded()

        timeLineCells.forEach { view in
            view.transform = .init(translationX: 0, y: -5)
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 1
                view.transform = .identity
            })
        }
    }
}
