// Copyright © 2025 com.flow-health. All rights reserved.

import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class ReceiptOcrResultViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let insertBookMarkMedicineUseCase: InsertBookMarkMedicineUseCase
    private let findBookMarkMedicineUseCase: FindBookMarkMedicineUseCase

    struct Input {
        let setOcrResult: Observable<[MedicineInfoEntity]>
        let tapOcrSelectionCell: Observable<IndexPath>
        let tapAddButton: Observable<Void>
    }
    
    struct Output {
        let ocrSelectionData: Driver<[(entity: MedicineInfoEntity, isSelect: Bool, isAlreadyAdd: Bool)]>
        let isAbleToNext: Driver<Bool>
    }

    init(
        insertBookMarkMedicineUseCase: InsertBookMarkMedicineUseCase,
        findBookMarkMedicineUseCase: FindBookMarkMedicineUseCase
    ) {
        self.insertBookMarkMedicineUseCase = insertBookMarkMedicineUseCase
        self.findBookMarkMedicineUseCase = findBookMarkMedicineUseCase
    }

    func transform(input: Input) -> Output {
        let ocrSelectionDataRelay = BehaviorRelay<[(entity: MedicineInfoEntity, isSelect: Bool, isAlreadyAdd: Bool)]>(value: [])
        let isAbleToNextRelay = BehaviorRelay<Bool>(value: false)
        
        input.setOcrResult
            .flatMap { result in
                let observables = result.map { entity -> Single<(entity: MedicineInfoEntity, isSelect: Bool, isAlreadyAdd: Bool)> in
                    self.findBookMarkMedicineUseCase.execute(with: entity.itemCode)
                        .map { (entity, false, $0 != nil) }
                }

                return Single.zip(observables)
            }
            .bind(to: ocrSelectionDataRelay)
            .disposed(by: disposeBag)

        input.tapOcrSelectionCell
            .withLatestFrom(ocrSelectionDataRelay) { indexPath, dataList in
                dataList.enumerated().map {
                    $0 != indexPath.row ? $1 : ($1.entity, !$1.isSelect, $1.isAlreadyAdd)
                }
            }
            .do(onNext: { dataList in
                // 하나라도 선택된 값이 있는지 확인
                let status = dataList.reduce(false) { $0 || $1.isSelect }
                isAbleToNextRelay.accept(status)
            })
            .bind(to: ocrSelectionDataRelay)
            .disposed(by: disposeBag)

        input.tapAddButton
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(ocrSelectionDataRelay) { _, dataList in
                dataList.filter { $0.isSelect }.map { $0.entity }
            }
            .flatMap { entities -> Observable<Step> in
                self.insertBookMarkMedicineUseCase.execute(with: entities)
                    .andThen(.just(FlowStep.receiptOcrEndIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            ocrSelectionData: ocrSelectionDataRelay.asDriver(),
            isAbleToNext: isAbleToNextRelay.asDriver()
        )
    }
}
