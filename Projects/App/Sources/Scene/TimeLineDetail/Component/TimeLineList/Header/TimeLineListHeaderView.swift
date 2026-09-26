// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import RxSwift
import RxCocoa
import SnapKit

class TimeLineListHeaderView: UICollectionReusableView {
    public static let identifier = "timeline.list.header.view"

    private(set) var disposeBag = DisposeBag()

    let dateSelector = DateSelector()
    let resetButton = FlowPaddingButton(buttonTitle: "오늘로 돌아가기")
    private let timeLineHeaderLable = TimeLineHeaderLabel()

    var countBinder: Binder<Int> {
        Binder(timeLineHeaderLable) { label, count in
            label.setCountOfMedicine(with: count)
        }
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
        disposeBag = DisposeBag()
    }

    func configure(dateRelay: BehaviorRelay<Date>) {
        dateSelector.configure(with: dateRelay)

        resetButton.rx.tap
            .map { Date() }
            .bind(to: dateRelay)
            .disposed(by: disposeBag)
    }

    private func addView() {
        [
            dateSelector,
            timeLineHeaderLable,
            resetButton
        ].forEach(addSubview(_:))
    }

    private func setAutoLayout() {
        dateSelector.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.horizontalEdges.equalToSuperview().inset(22)
        }

        timeLineHeaderLable.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.top.equalTo(dateSelector.snp.bottom).offset(10)
        }

        resetButton.snp.makeConstraints {
            $0.top.equalTo(timeLineHeaderLable.snp.bottom).offset(8)
            $0.leading.equalTo(timeLineHeaderLable)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
}
