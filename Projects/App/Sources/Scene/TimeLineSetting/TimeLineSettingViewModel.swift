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
        let deleteFailed: Signal<Void>
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
        let deleteFailed = PublishRelay<Void>()
        let reloadTrigger = PublishRelay<Date>()

        // 조회 실패 시 기존 목록 유지
        Observable.merge(input.selectedDate, reloadTrigger.asObservable())
            .flatMapLatest { [fetchTakenMedicineListUseCase] date in
                fetchTakenMedicineListUseCase.execute(at: date)
                    .asObservable()
                    .catch { _ in .empty() }
            }
            .subscribe(onNext: {
                takenMedicineData.accept($0)
                isHiddenEmptyView.accept(!$0.isEmpty)
            })
            .disposed(by: disposeBag)

        input.deleteRowIDs
            .filter { !$0.isEmpty }
            .withLatestFrom(input.selectedDate) { ($0, $1) }
            .flatMapLatest { [deleteTakenMedicineUseCase] rowIDs, date -> Observable<Event<(Int, Date)>> in
                deleteTakenMedicineUseCase.execute(rowIDs: rowIDs)
                    .andThen(Observable.just((rowIDs.count, date)))
                    .materialize()
            }
            .subscribe(onNext: { event in
                switch event {
                case .next(let (count, date)):
                    deleteCompleted.accept(count)
                    reloadTrigger.accept(date)
                case .error:
                    deleteFailed.accept(())
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)

        return Output(
            takenMedicineData: takenMedicineData.asDriver(),
            isHiddenEmptyView: isHiddenEmptyView.asDriver(),
            deleteCompleted: deleteCompleted.asSignal(),
            deleteFailed: deleteFailed.asSignal()
        )
    }
}
