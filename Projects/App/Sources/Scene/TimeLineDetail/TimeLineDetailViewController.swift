import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class TimeLineDetailViewController: BaseVC<TimeLineDetailViewModel> {
    private let dateSelector = DateSelector()
    private let timeLineHeaderLable = TimeLineHeaderLabel()
    private let resetButton = ResetDateButton()
    private let timeLineDetailListView = TimeLineDetailListView()

    override func attridute() {
        navigationItem.title = "타임라인"
        view.backgroundColor = .white
    }

    override func addView() {
        view.addSubViews(
            dateSelector,
            timeLineHeaderLable,
            resetButton,
            timeLineDetailListView
        )
    }

    override func setLayout() {
        dateSelector.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.leading.equalToSuperview().inset(22)
        }
        timeLineHeaderLable.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(22)
            $0.top.equalTo(dateSelector.snp.bottom).offset(10)
        }
        resetButton.snp.makeConstraints {
            $0.top.equalTo(timeLineHeaderLable.snp.bottom).offset(8)
            $0.leading.equalTo(timeLineHeaderLable)
        }
        timeLineDetailListView.snp.makeConstraints {
            $0.top.equalTo(resetButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
    }

    override func bind() {
        let input = TimeLineDetailViewModel.Input(
            selectedDate: dateSelector.selectDate.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.takenMedicineData.asObservable()
            .do(onNext: { [weak self] in
                self?.timeLineHeaderLable.setCountOfMedicine(with: $0.count)
            })
            .subscribe(onNext: timeLineDetailListView.setTimeLineList(with:))
            .disposed(by: disposeBag)

        resetButton.rx.tap
            .map { Date() }
            .bind(to: dateSelector.selectDate)
            .disposed(by: disposeBag)
    }
}
