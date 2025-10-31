// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Model

import SnapKit
import Then

class TimeLineView: BaseView {

    let headerView = HeaderNavigationButton().then {
        $0.isUserInteractionEnabled = false
    }

    private let timeLineVStack = VStack()
    private let timeLineEmptyView = EmptyStatusView(
        icon: FlowKitAsset.pageWithCloud.image,
        title: "기록된 정보가 없습니다",
        subTitle: "복용한 약을 기록하여\n타임라인을 만들어 보세요"
    )

    init(isNavigatAble: Bool = true) {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        backgroundColor = .white
        headerView.isEnabled = isNavigatAble
        headerView.setHeader("타임라인")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addView() {
        addSubViews(
            headerView,
            timeLineVStack
        )
    }

    override func setAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(24)
        }
        timeLineVStack.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(timeLineVStack).offset(20)
        }
    }
}

extension TimeLineView {
    func addTimeLine(_ entity: [MedicineTakenEntity]) {
        let subViews = timeLineVStack.subviews
        subViews.forEach(timeLineVStack.removeArrangedSubview(_:))
        subViews.forEach { $0.removeFromSuperview() }

        guard !entity.isEmpty else {
            timeLineVStack.addArrangedSubview(timeLineEmptyView)
            return
        }

        let timeLineCells = entity.enumerated().map {
            let cell = TimeLineCell(
                isFirst: $0.offset == 0,
                isLast: $0.offset == entity.count - 1,
                time: $0.element.takenTime.toString(.nomal),
                medicineName: $0.element.medicineInfo.medicineName
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
