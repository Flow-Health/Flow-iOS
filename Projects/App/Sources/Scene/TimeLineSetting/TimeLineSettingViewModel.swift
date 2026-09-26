// Copyright © 2026 com.flow-health. All rights reserved.

import Foundation
import FlowService
import Model
import Core

import RxFlow
import RxSwift
import RxCocoa

class TimeLineSettingViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase
    private let deleteTakenMedicineUseCase: DeleteTakenMedicineUseCase

    struct Input {
        let selectedDate: Observable<Date>
        let deleteRowIDs: Observable<[Int64]>
    }

    struct Output {
        let takenMedicineData: Driver<[MedicineTakenEntity]>
        let isHiddenEmptyView: Driver<Bool>
        let deleteCompleted: Signal<Int>
    }

    init(
        fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase,
        deleteTakenMedicineUseCase: DeleteTakenMedicineUseCase
    ) {
        self.fetchTakenMedicineListUseCase = fetchTakenMedicineListUseCase
        self.deleteTakenMedicineUseCase = deleteTakenMedicineUseCase
    }

    func transform(input: Input) -> Output {
        let takenMedicineData = BehaviorRelay<[MedicineTakenEntity]>(value: [])
        let isHiddenEmptyView = BehaviorRelay<Bool>(value: true)
        let deleteCompleted = PublishRelay<Int>()
        let reloadTrigger = PublishRelay<Date>()

        Observable.merge(input.selectedDate, reloadTrigger.asObservable())
            .flatMapLatest { [fetchTakenMedicineListUseCase] in
                fetchTakenMedicineListUseCase.execute(at: $0)
            }
            .subscribe(onNext: {
                takenMedicineData.accept($0)
                isHiddenEmptyView.accept(!$0.isEmpty)
            })
            .disposed(by: disposeBag)

        input.deleteRowIDs
            .filter { !$0.isEmpty }
            .withLatestFrom(input.selectedDate) { ($0, $1) }
            .flatMapLatest { [deleteTakenMedicineUseCase] rowIDs, date -> Single<(Int, Date)> in
                deleteTakenMedicineUseCase.execute(rowIDs: rowIDs)
                    .andThen(.just((rowIDs.count, date)))
            }
            .subscribe(onNext: { count, date in
                deleteCompleted.accept(count)
                reloadTrigger.accept(date)
            })
            .disposed(by: disposeBag)

        return Output(
            takenMedicineData: takenMedicineData.asDriver(),
            isHiddenEmptyView: isHiddenEmptyView.asDriver(),
            deleteCompleted: deleteCompleted.asSignal()
        )
    }
}
