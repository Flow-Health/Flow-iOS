import Foundation
import FlowService
import Model
import Core

import RxSwift
import RxCocoa
import RxFlow

class SearchViewModel: ViewModelType, Stepper {
    var steps: PublishRelay<Step> = .init()
    var disposeBag: DisposeBag = .init()

    private let searchMedicineUseCase: SearchMedicineUseCase
    private var searchResultList: [MedicineInfoEntity] = []

    struct Input {
        let searchInputText: Observable<String>
        let selectedItemIndex: Observable<IndexPath>
        let onTapCreateMyMedicineButton: Observable<Void>
    }
    
    struct Output { 
        let resultMedicine: Signal<[MedicineInfoEntity]>
    }

    init(searchMedicineUseCase: SearchMedicineUseCase) {
        self.searchMedicineUseCase = searchMedicineUseCase
    }

    func transform(input: Input) -> Output {
        let searchMedicine = PublishRelay<[MedicineInfoEntity]>()

        input.searchInputText
            .filter { !$0.isEmpty }
            .debounce(.milliseconds(600), scheduler: MainScheduler.asyncInstance)
            .flatMap {
                self.searchMedicineUseCase.execute(with: $0)
                    .catch {
                        debugPrint($0.localizedDescription)
                        return .just([])
                    }
            }
            .do(onNext: { [weak self] in self?.searchResultList = $0 })
            .bind(to: searchMedicine)
            .disposed(by: disposeBag)

        input.selectedItemIndex
            .map { FlowStep.madicineDetailIsRequired(with: self.searchResultList[$0.item]) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.onTapCreateMyMedicineButton
            .map { FlowStep.createMyMedicineIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
            
        return Output(resultMedicine: searchMedicine.asSignal())
    }
}
