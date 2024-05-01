// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import FlowKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class DatePickerViewController: UIViewController {

    let disposBag = DisposeBag()
    private var selectedDate: Date?
    private let complition: (Date?) -> Void

    private let dateBackgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }

    private let datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .inline
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
        $0.timeZone = .autoupdatingCurrent
        $0.maximumDate = Date()
    }

    init(complition: @escaping (Date?) -> Void) {
        self.complition = complition
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateBackgroundView.transform = .init(translationX: 0, y: view.frame.height)
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        presentWithAnimation()
    }

    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        dismissWithAnimation()
    }

    override func viewDidLayoutSubviews() {
        addView()
        setLayout()
    }

    private func addView() {
        view.addSubview(dateBackgroundView)
        dateBackgroundView.addSubview(datePicker)
    }

    private func setLayout() {
        dateBackgroundView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo((view.frame.height / 2) + 30)
            $0.bottom.greaterThanOrEqualToSuperview().offset(10)
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(dateBackgroundView).inset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(dateBackgroundView).inset(10)
        }
    }

    private func bind() {
        datePicker.rx.date
            .bind(
                with: self,
                onNext: { owner, date in owner.selectedDate = date }
            )
            .disposed(by: disposBag)
    }
}

extension DatePickerViewController {
    func initDate(_ date: Date) {
        datePicker.setDate(date, animated: false)
    }

    private func presentWithAnimation() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0
        ) { [self] in
            view.backgroundColor = .black.withAlphaComponent(0.4)
            dateBackgroundView.transform = .identity
        }
    }

    private func dismissWithAnimation() {
        complition(selectedDate)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.1,
            animations: { [self] in
                view.layer.opacity = 0
                dateBackgroundView.transform = .init(translationX: 0, y: view.frame.height)
            },
            completion: { [self] _ in dismiss(animated: false) }
        )
    }
}
