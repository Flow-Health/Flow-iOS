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
    private let updateBookMarkMedicineUseCase: UpdateBookMarkMedicineUseCase

    struct Input { 
        let itemCode: Observable<String>
        let insetBookMarkItem: Observable<MedicineInfoEntity?>
        let deleteBookMarkItem: Observable<MedicineInfoEntity?>
        let updateBookMarkItem: Observable<MedicineInfoEntity?>
    }
    
    struct Output {
        let isBookMarked: Driver<Bool>
        let tagColorHexCode: Driver<String?>
    }

    init(
        findBookMarkMedicineUseCase: FindBookMarkMedicineUseCase,
        deleteBookMarkMedicineUseCase: DeleteBookMarkMedicineUseCase,
        insertBookMarkMedicineUseCase: InsertBookMarkMedicineUseCase,
        updateBookMarkMedicineUseCase: UpdateBookMarkMedicineUseCase
    ) {
        self.findBookMarkMedicineUseCase = findBookMarkMedicineUseCase
        self.deleteBookMarkMedicineUseCase = deleteBookMarkMedicineUseCase
        self.insertBookMarkMedicineUseCase = insertBookMarkMedicineUseCase
        self.updateBookMarkMedicineUseCase = updateBookMarkMedicineUseCase
    }

    func transform(input: Input) -> Output {
        let isBookMarkedRelay = BehaviorRelay<Bool>(value: false)
        let tagColorHexCode = BehaviorRelay<String?>(value: nil)

        input.itemCode
            .flatMap {
                self.findBookMarkMedicineUseCase.execute(with: $0)
            }
            .subscribe(onNext: {
                isBookMarkedRelay.accept($0 != nil)
                tagColorHexCode.accept($0?.tagHexColorCode)
            })
            .disposed(by: disposeBag)

        input.deleteBookMarkItem
            .compactMap { $0 }
            .do(onNext: { _ in tagColorHexCode.accept(nil) })
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

        input.updateBookMarkItem
            .compactMap { $0 }
            .flatMap { entity -> Single in
                self.updateBookMarkMedicineUseCase.execute(to: entity, at: entity.itemCode)
                    .andThen(.just(()))
            }
            .subscribe(onNext: { }) // TODO: Tag update notification
            .disposed(by: disposeBag)

        return Output(
            isBookMarked: isBookMarkedRelay.asDriver(),
            tagColorHexCode: tagColorHexCode.asDriver()
        )
    }
}
