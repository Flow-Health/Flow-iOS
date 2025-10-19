import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class SearchViewController: BaseVC<SearchViewModel> {

    private let onScrollButtomEndRelay = PublishRelay<Void>()
    private var isBottomCellVisible: Bool = false

    private let resultTableView = UITableView().then {
        $0.backgroundColor = .black6
        $0.register(SearchResultTableCell.self, forCellReuseIdentifier: SearchResultTableCell.identifier)
        $0.rowHeight = 120
        $0.keyboardDismissMode = .onDrag
    }

    private let noFoundVStackView = VStack().then {
        $0.isHidden = true
    }

    private let notFoundMainLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .headerH3SemiBold
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    private let notFoundSubLabel = UILabel().then {
        $0.text = "원하는 약을 찾을 수 없으신가요?"
        $0.textColor = .black2
        $0.font = .bodyB1Medium
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let creactMyMedicineButton = BaseButton().then {
        $0.setTitle("나만의 약 추가하기", for: .normal)
        $0.setTitleColor(.blue1, for: .normal)
        $0.titleLabel?.font = .bodyB1Bold
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.blue1.cgColor
        $0.layer.cornerRadius = 5
    }

    private let searchEmptyView = EmptyStatusView(
        icon: FlowKitAsset.readingGlassesWithCloud.image,
        title: "원하는 약을 검색하고, 찾아보세요!",
        subTitle: "식약처 데이터를 사용하여 정확한 정보를 제공해드려요"
    )

    private let searchController = SearchBarController()

    override func attridute() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "약 검색"
    }

    override func addView() {
        view.addSubViews(searchEmptyView, resultTableView)
        resultTableView.addSubview(noFoundVStackView)

        // NotFound일때, 나오는 요소들 세팅
        noFoundVStackView.addArrangedSubviews([
            notFoundMainLabel,
            notFoundSubLabel,
            creactMyMedicineButton
        ])
    }

    override func setAutoLayout() {
        searchEmptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        resultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.bottom.equalToSuperview()
        }

        noFoundVStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.leading.trailing.equalToSuperview().offset(40)
        }

        noFoundVStackView.setCustomSpacing(5, after: notFoundMainLabel)
        noFoundVStackView.setCustomSpacing(15, after: notFoundSubLabel)
    }

    override func bind() {
        let input = SearchViewModel.Input(
            searchInputText: searchController.searchBar.searchTextField.rx.text.orEmpty.asObservable(),
            selectedItemIndex: resultTableView.rx.itemSelected.asObservable(),
            onTapCreateMyMedicineButton: creactMyMedicineButton.rx.tap.asObservable(),
            onScrollButtomEnd: onScrollButtomEndRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.resultMedicine
            .filter {
                $0.searchText == (self.searchController.searchBar.searchTextField.text ?? "").trimmingCharacters(in: .whitespaces)
            }
            .do(onNext: { [weak self] in
                guard let self, !$0.searchText.isEmpty else { return }
                noFoundVStackView.isHidden = !$0.result.isEmpty
                notFoundMainLabel.text = "\"\($0.searchText)\"를 찾을 수 없음"
            })
            .map { $0.result }
            .drive(resultTableView.rx.items(
                cellIdentifier: SearchResultTableCell.identifier,
                cellType: SearchResultTableCell.self
            )) { _, data, cell in
                cell.setup(data)
            }
            .disposed(by: disposeBag)

        resultTableView.rx.contentOffset
            .subscribe(onNext: { [weak self] (contentOffset) in
                guard let self, resultTableView.contentSize.height > 0 else { return }

                let contentHight = resultTableView.contentSize.height
                let offsetY = contentOffset.y
                let height = resultTableView.frame.size.height

                // 최하단으로 스크롤시 페이지네이션 진행
                if offsetY + height >= contentHight - 50 {
                    if !isBottomCellVisible {
                        onScrollButtomEndRelay.accept(())
                        isBottomCellVisible = true
                    }
                } else {
                    isBottomCellVisible = false
                }
            })
            .disposed(by: disposeBag)

        searchController.searchBar.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                searchEmptyView.isHidden = !$0
                resultTableView.isHidden = $0
                noFoundVStackView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}
