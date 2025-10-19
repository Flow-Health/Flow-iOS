import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxGesture
import RxSwift
import RxCocoa

class TimeLineDetailViewController: BaseVC<TimeLineDetailViewModel> {
    private lazy var scrollView = VScrollView(
        isRefreshAble: true,
        refreshAction: { [self] in
            let currentDate = dateSelector.selectDate.value
            dateSelector.selectDate.accept(currentDate)
        }
    )
    private let dateSelector = DateSelector()
    private let timeLineHeaderLable = TimeLineHeaderLabel()
    private let resetButton = FlowPaddingButton(buttonTitle: "오늘로 돌아가기")
    private let timeLineDetailListView = TimeLineDetailListView()
    
    override func attridute() {
        navigationItem.title = "타임라인"
        view.backgroundColor = .white
    }
    
    override func addView() {
        view.addSubview(scrollView)
        scrollView.contentView.addSubViews(
            dateSelector,
            timeLineHeaderLable,
            resetButton,
            timeLineDetailListView
        )
    }
    
    override func setAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.trailing.leading.equalToSuperview()
        }
        scrollView.contentView.snp.makeConstraints {
            $0.bottom.equalTo(timeLineDetailListView)
        }
        dateSelector.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.horizontalEdges.equalToSuperview().inset(22)
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

        view.rx.swipeGesture([.right, .left])
            .skip(2)
            .map {
                let currentSelectDate = self.dateSelector.selectDate.value
                let addDate = $0.direction == .right ? -1 : 1
                return Calendar.current.date(byAdding: .day, value: addDate, to: currentSelectDate)!
            }
            .filter {
                let overDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                return $0.toString(.fullDate) != overDate.toString(.fullDate)
            }
            .bind(to: dateSelector.selectDate)
            .disposed(by: disposeBag)

        resetButton.rx.tap
            .map { Date() }
            .bind(to: dateSelector.selectDate)
            .disposed(by: disposeBag)
        
        dateSelector.dateDisplayLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                let dateVC = DatePickerViewController(complition: {
                    guard let selectedDate = $0,
                          selectedDate != self.dateSelector.selectDate.value
                    else { return }
                    self.dateSelector.selectDate.accept(selectedDate)
                })
                dateVC.initDate(dateSelector.selectDate.value)
                present(dateVC, animated: false)
            })
            .disposed(by: disposeBag)
    }
}
