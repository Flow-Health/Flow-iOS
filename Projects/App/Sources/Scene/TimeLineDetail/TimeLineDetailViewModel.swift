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
    }
    
    struct Output {
        let takenMedicineData: Driver<[MedicineTakenEntity]>
    }

    init(fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase) {
        self.fetchTakenMedicineListUseCase = fetchTakenMedicineListUseCase
    }

    func transform(input: Input) -> Output {
        let takenMedicineData = BehaviorRelay<[MedicineTakenEntity]>(value: [])

        input.selectedDate
            .flatMap {
                self.fetchTakenMedicineListUseCase.execute(at: $0)
            }
            .bind(to: takenMedicineData)
            .disposed(by: disposeBag)

        return Output(takenMedicineData: takenMedicineData.asDriver())
    }
}
