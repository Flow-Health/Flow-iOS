// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class DateSelector: BaseView {

    let selectDate = BehaviorRelay<Date>(value: Date())

    private let disposeBag = DisposeBag()

    private let decreaseDateButton = UIButton().then {
        $0.setImage(FlowKitAsset.leftFillArrow.image, for: .normal)
    }

    private let increaseDateButton = UIButton().then {
        $0.setImage(FlowKitAsset.rightFillArrow.image, for: .normal)
    }

    private let dateDisplayLable = UILabel().then {
        $0.customLabel("-년 -월 -일", font: .headerH3SemiBold, textColor: .black)
    }

    override func addView() {
        addSubViews(
            decreaseDateButton,
            increaseDateButton,
            dateDisplayLable
        )
    }

    override func setLayout() {
        decreaseDateButton.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        increaseDateButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(dateDisplayLable.snp.trailing).offset(8)
        }
        dateDisplayLable.snp.makeConstraints {
            $0.leading.equalTo(decreaseDateButton.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        self.snp.makeConstraints {
            $0.bottom.equalTo(decreaseDateButton.snp.bottom)
            $0.trailing.equalTo(increaseDateButton)
        }
    }

    override func bind() {
        selectDate
            .map { 
                let currentDate = Calendar.current.dateComponents([.year], from: Date())
                let selectedDate = Calendar.current.dateComponents([.year], from: $0)
                return $0.toString(
                    currentDate.year == selectedDate.year ?
                    .mounthAndDateWithCharacter :
                    .fullDateWithCharacter
                )
            }
            .bind(to: dateDisplayLable.rx.text)
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
