// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class DateSelector: BaseView {

    let selectDate = BehaviorRelay<Date>(value: Date())

    private let decreaseDateButton = UIButton().then {
        $0.setImage(FlowKitAsset.leftFillArrow.image, for: .normal)
    }

    private let increaseDateButton = UIButton().then {
        $0.setImage(FlowKitAsset.rightFillArrow.image, for: .normal)
    }

    let dateDisplayLabel = UILabel().then {
        $0.customLabel(font: .headerH3SemiBold, textColor: .black)
        $0.clipsToBounds = true
    }

    override func addView() {
        addSubViews(
            decreaseDateButton,
            increaseDateButton,
            dateDisplayLabel
        )
    }

    override func setLayout() {
        decreaseDateButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        increaseDateButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(dateDisplayLabel.snp.trailing).offset(8)
        }
        dateDisplayLabel.snp.makeConstraints {
            $0.leading.equalTo(decreaseDateButton.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(decreaseDateButton)
        }
    }

    override func bind() {
        selectDate
            .do(onNext: buttonHandling(_:))
            .map {
                let currentDate = Calendar.current.dateComponents([.year], from: Date())
                let selectedDate = Calendar.current.dateComponents([.year], from: $0)
                return $0.toString(
                    currentDate.year == selectedDate.year ?
                    .mounthAndDateWithCharacter :
                    .fullDateWithCharacter
                )
            }
            .bind(onNext: changeDateWithAnimation(_:))
            .disposed(by: disposeBag)

        decreaseDateButton.rx.tap
            .map {
                let currentSelectDate = self.selectDate.value
                return Calendar.current.date(byAdding: .day, value: -1, to: currentSelectDate)!
            }
            .bind(to: selectDate)
            .disposed(by: disposeBag)

        increaseDateButton.rx.tap
            .map {
                let currentSelectDate = self.selectDate.value
                return Calendar.current.date(byAdding: .day, value: 1, to: currentSelectDate)!
            }
            .bind(to: selectDate)
            .disposed(by: disposeBag)
    }
}

extension DateSelector {
    private func buttonHandling(_ date: Date) {
        increaseDateButton.isEnabled = !(date.toString(.fullDate) == Date().toString(.fullDate))
    }

    private func changeDateWithAnimation(_ content: String) {
        dateDisplayLabel.text = content
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = .init(name: .default)
        transition.type = .fade
        dateDisplayLabel.layer.add(transition, forKey: CATransitionType.fade.rawValue)
    }
}
