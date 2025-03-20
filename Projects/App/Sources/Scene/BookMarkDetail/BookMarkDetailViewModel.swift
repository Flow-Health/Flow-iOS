import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class BookMarkDetailViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let fetchBookMarkMedicineListUseCase: FetchBookMarkMedicineListUseCase

    private var bookMarkResultList: [MedicineInfoEntity] = []

    struct Input {
        let viewWillAppear: Observable<Void>
        let selectedItemIndex: Observable<IndexPath>
        let onTapCreateMyMedicineButton: Observable<Void>
    }

    struct Output {
        let bookMarkList: Driver<[MedicineInfoEntity]>
    }

    init(fetchBookMarkMedicineListUseCase: FetchBookMarkMedicineListUseCase) {
        self.fetchBookMarkMedicineListUseCase = fetchBookMarkMedicineListUseCase
    }

    func transform(input: Input) -> Output {
        let bookMarkList = BehaviorRelay<[MedicineInfoEntity]>(value: [])

        input.viewWillAppear
            .flatMap {
                self.fetchBookMarkMedicineListUseCase.execute()
            }
            .do(onNext: { [weak self] in self?.bookMarkResultList = $0 })
            .bind(to: bookMarkList)
            .disposed(by: disposeBag)

        input.selectedItemIndex
            .map { FlowStep.madicineDetailIsRequired(with: self.bookMarkResultList[$0.item])}
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        input.onTapCreateMyMedicineButton
            .subscribe(onNext: {
                print("내 약 만들기 클릭")
            })
            .disposed(by: disposeBag)

        return Output(bookMarkList: bookMarkList.asDriver())
    }
}
