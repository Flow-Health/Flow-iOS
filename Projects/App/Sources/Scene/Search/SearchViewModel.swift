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
        let resultMedicine: Signal<(searchText: String, result: [MedicineInfoEntity])>
    }

    init(searchMedicineUseCase: SearchMedicineUseCase) {
        self.searchMedicineUseCase = searchMedicineUseCase
    }

    func transform(input: Input) -> Output {
        let searchMedicine = PublishRelay<(searchText: String, result: [MedicineInfoEntity])>()

        input.searchInputText
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(600), scheduler: MainScheduler.asyncInstance)
            .flatMap {
                self.searchMedicineUseCase.execute(with: $0)
                    .catch {
                        debugPrint($0.localizedDescription)
                        return .just([])
                    }
            }
            .withLatestFrom(
                input.searchInputText,
                resultSelector: { (searchText: $1.trimmingCharacters(in: .whitespaces), result: $0)
            })
            .do(onNext: { [weak self] in self?.searchResultList = $0.result })
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
