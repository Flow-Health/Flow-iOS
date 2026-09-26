import Foundation
import FlowService
import Model
import Core

import RxFlow
import RxSwift
import RxCocoa

class TimeLineDetailViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase

    struct Input {
        let selectedDate: Observable<Date>
        let openTimeLineSetting: Observable<Date>
    }
    
    struct Output {
        let takenMedicineData: Driver<[MedicineTakenEntity]>
        let isHiddenEmptyView: Driver<Bool>
    }

    init(fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase) {
        self.fetchTakenMedicineListUseCase = fetchTakenMedicineListUseCase
    }

    func transform(input: Input) -> Output {
        let takenMedicineData = BehaviorRelay<[MedicineTakenEntity]>(value: [])
        let isHiddenEmptyView = BehaviorRelay<Bool>(value: true)

        input.selectedDate
            .flatMap {
                self.fetchTakenMedicineListUseCase.execute(at: $0)
            }
            .subscribe(onNext: {
                takenMedicineData.accept($0)
                isHiddenEmptyView.accept(!$0.isEmpty)
            })
            .disposed(by: disposeBag)
        
        input.openTimeLineSetting
            .map { FlowStep.timeLineSettingIsRequired(date: $0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            takenMedicineData: takenMedicineData.asDriver(),
            isHiddenEmptyView: isHiddenEmptyView.asDriver()
        )
    }
}
