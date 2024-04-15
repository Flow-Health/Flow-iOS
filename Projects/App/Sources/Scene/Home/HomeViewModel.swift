import Foundation
import FlowService
import Model
import Core

import RxFlow
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType, Stepper {

    var steps: PublishRelay<Step> = .init()

    var disposeBag: DisposeBag = .init()

    private let fetchMedicineRecodeUseCase: FetchMedicineRecodeUseCase
    private let fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase
    private let fetchBookMarkMedicineListUseCase: FetchBookMarkMedicineListUseCase

    struct Input { 
        let viewWillAppear: Observable<Void>
        let tapSearchButton: Observable<Void>
        let tapBookMarkNavigationButton: Observable<Void>
    }

    struct Output {
        let lastTakenTime: Driver<String?>
        let bookMarkList: Driver<[MedicineInfoEntity]>
        let timeLineList: Driver<[MedicineTakenEntity]>
    }

    init(
        fetchMedicineRecodeUseCase: FetchMedicineRecodeUseCase,
        fetchTakenMedicineListUseCase: FetchTakenMedicineListUseCase,
        fetchBookMarkMedicineListUseCase: FetchBookMarkMedicineListUseCase
    ) {
        self.fetchMedicineRecodeUseCase = fetchMedicineRecodeUseCase
        self.fetchTakenMedicineListUseCase = fetchTakenMedicineListUseCase
        self.fetchBookMarkMedicineListUseCase = fetchBookMarkMedicineListUseCase
    }

    func transform(input: Input) -> Output {
        let timeLineList = BehaviorRelay<[MedicineTakenEntity]>(value: [])
        let bookMarkList = BehaviorRelay<[MedicineInfoEntity]>(value: [])
        let lastTakenTime = BehaviorRelay<String?>(value: nil)

        input.viewWillAppear
            .flatMap { self.fetchTakenMedicineListUseCase.execute() }
            .bind(to: timeLineList)
            .disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap { self.fetchBookMarkMedicineListUseCase.execute() }
            .bind(to: bookMarkList)
            .disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap { self.fetchMedicineRecodeUseCase.execute() }
            .map { $0?.lastTakenTime.toString(.nomal) }
            .bind(to: lastTakenTime)
            .disposed(by: disposeBag)

        return Output(
            lastTakenTime: lastTakenTime.asDriver(),
            bookMarkList: bookMarkList.asDriver(),
            timeLineList: timeLineList.asDriver()
        )
    }
}
