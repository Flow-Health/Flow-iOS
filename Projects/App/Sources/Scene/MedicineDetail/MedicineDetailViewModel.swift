import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class MedicineDetailViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let findBookMarkMedicineUseCase: FindBookMarkMedicineUseCase
    private let deleteBookMarkMedicineUseCase: DeleteBookMarkMedicineUseCase
    private let insertBookMarkMedicineUseCase: InsertBookMarkMedicineUseCase

    private let isBookMarkedRelay = BehaviorRelay<Bool>(value: false)

    struct Input { 
        let itemCode: Observable<String>
        let insetBookMarkItem: Observable<MedicineInfoEntity?>
        let deleteBookMarkItem: Observable<MedicineInfoEntity?>
    }
    
    struct Output {
        let isBookMarked: Driver<Bool>
    }

    init(
        findBookMarkMedicineUseCase: FindBookMarkMedicineUseCase,
        deleteBookMarkMedicineUseCase: DeleteBookMarkMedicineUseCase,
        insertBookMarkMedicineUseCase: InsertBookMarkMedicineUseCase
    ) {
        self.findBookMarkMedicineUseCase = findBookMarkMedicineUseCase
        self.deleteBookMarkMedicineUseCase = deleteBookMarkMedicineUseCase
        self.insertBookMarkMedicineUseCase = insertBookMarkMedicineUseCase
    }

    func transform(input: Input) -> Output {

        input.itemCode
            .flatMap {
                self.findBookMarkMedicineUseCase.execute(with: $0)
            }
            .map { $0 != nil }
            .bind(to: isBookMarkedRelay)
            .disposed(by: disposeBag)

        input.deleteBookMarkItem
            .compactMap { $0 }
            .flatMap { entity -> Single in
                self.deleteBookMarkMedicineUseCase.execute(with: entity.itemCode)
                    .andThen(.just(false))
            }
            .bind(to: isBookMarkedRelay)
            .disposed(by: disposeBag)
            

        input.insetBookMarkItem
            .compactMap { $0 }
            .flatMap { entity -> Single in
                self.insertBookMarkMedicineUseCase.execute(with: entity)
                    .andThen(.just(true))
            }
            .bind(to: isBookMarkedRelay)
            .disposed(by: disposeBag)

        return Output(isBookMarked: isBookMarkedRelay.asDriver())
    }
}
