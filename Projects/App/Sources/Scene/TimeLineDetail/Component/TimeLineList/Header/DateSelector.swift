// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import RxSwift
import RxGesture
import RxCocoa
import SnapKit
import Then

class DateSelector: BaseView {

    private var selectDate: BehaviorRelay<Date>?
    private var externalBag = DisposeBag()

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

    func configure(with relay: BehaviorRelay<Date>) {
        selectDate = relay
        externalBag = DisposeBag()

        relay
            .do(onNext: { [weak self] in self?.buttonHandling($0) })
            .map {
                let currentDate = Calendar.current.dateComponents([.year], from: Date())
                let selectedDate = Calendar.current.dateComponents([.year], from: $0)
                return $0.toString(
                    currentDate.year == selectedDate.year ?
                    .mounthAndDateWithCharacter :
                    .fullDateWithCharacter
                )
            }
            .bind(onNext: { [weak self] in self?.changeDateWithAnimation($0) })
            .disposed(by: externalBag)

        decreaseDateButton.rx.tap
            .withLatestFrom(relay)
            .map { Calendar.current.date(byAdding: .day, value: -1, to: $0)! }
            .bind(to: relay)
            .disposed(by: externalBag)

        increaseDateButton.rx.tap
            .withLatestFrom(relay)
            .map { Calendar.current.date(byAdding: .day, value: 1, to: $0)! }
            .bind(to: relay)
            .disposed(by: externalBag)

        dateDisplayLabel.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.presentDatePicker()
            }
            .disposed(by: externalBag)
    }

    override func addView() {
        addSubViews(
            decreaseDateButton,
            increaseDateButton,
            dateDisplayLabel
        )
    }

    override func setAutoLayout() {
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

    private func presentDatePicker() {
        guard let selectDate else { return }
        let dateVC = DatePickerViewController(complition: { [weak selectDate] in
            guard let selectDate,
                  let selectedDate = $0,
                  selectedDate != selectDate.value
            else { return }
            selectDate.accept(selectedDate)
        })
        dateVC.initDate(selectDate.value)

        if let topVC = UIApplication.topViewController() {
            topVC.present(dateVC, animated: false)
        }
    }
}
