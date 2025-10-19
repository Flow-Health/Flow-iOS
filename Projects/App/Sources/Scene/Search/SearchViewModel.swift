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
    private var currntPageCount: Int = 1
    private var isCurrentPageEmpty: Bool = false

    struct Input {
        let searchInputText: Observable<String>
        let selectedItemIndex: Observable<IndexPath>
        let onTapCreateMyMedicineButton: Observable<Void>
        let onScrollButtomEnd: Observable<Void>
    }
    
    struct Output { 
        let resultMedicine: Driver<(searchText: String, result: [MedicineInfoEntity])>
    }

    init(searchMedicineUseCase: SearchMedicineUseCase) {
        self.searchMedicineUseCase = searchMedicineUseCase
    }

    func transform(input: Input) -> Output {
        let searchMedicine = BehaviorRelay<(searchText: String, result: [MedicineInfoEntity])>(value: ("", []))

        input.searchInputText
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .distinctUntilChanged()
            .debounce(.milliseconds(600), scheduler: MainScheduler.asyncInstance)
            .filter {
                // 검색어가 비어있을 경우, 빈배열 결과로 보내기
                guard !$0.isEmpty else {
                    searchMedicine.accept((searchText: "", result: []))
                    return false
                }

                return true
            }
            .flatMap { inputText in // 약 검색 API 호출
                self.currntPageCount = 1 // 페이지 1로 초기화

                return self.searchMedicineUseCase.execute(with: inputText, self.currntPageCount)
                    .map { searchList in
                        (searchText: inputText, result: searchList)
                    }
                    .catch {
                        debugPrint($0.localizedDescription)
                        return .just((searchText: inputText, result: []))
                    }
            }
            .do(onNext: { [weak self] in
                guard let self else { return }
                isCurrentPageEmpty = $0.result.isEmpty // 현재 페이지의 데이터 공백 여부 상태변경
                searchResultList = $0.result // searchResultList 검색 결과로 초기화
            })
            .bind(to: searchMedicine)
            .disposed(by: disposeBag)

        input.onScrollButtomEnd
            .filter { !self.isCurrentPageEmpty }
            .withLatestFrom(input.searchInputText)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .flatMap { inputText in // 약 검색 API 호출
                self.currntPageCount += 1 // currntPageCount에 1 더하기

                return self.searchMedicineUseCase.execute(with: inputText, self.currntPageCount)
                    .map { searchList in
                        (searchText: inputText, result: searchList)
                    }
                    .catch {
                        debugPrint($0.localizedDescription)
                        return .just((searchText: inputText, result: []))
                    }
            }
            .map {
                self.isCurrentPageEmpty = $0.result.isEmpty // 현재 페이지의 데이터 공백 여부 상태변경
                self.searchResultList += $0.result // searchResultList의 리스트와 호출 결과 합치기
                return (searchText: $0.searchText, result: self.searchResultList)
            }
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
            
        return Output(
            resultMedicine: searchMedicine.asDriver()
        )
    }
}
