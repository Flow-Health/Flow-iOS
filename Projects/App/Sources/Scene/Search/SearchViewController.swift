import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class SearchViewController: BaseVC<SearchViewModel> {
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

    private let searchController = SearchBarController()

    override func attridute() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "약 검색"
    }

    override func addView() {
        view.addSubview(resultTableView)
        resultTableView.addSubview(noFoundVStackView)

        // NotFound일때, 나오는 요소들 세팅
        noFoundVStackView.addArrangedSubviews([
            notFoundMainLabel,
            notFoundSubLabel,
            creactMyMedicineButton
        ])
    }

    override func setLayout() {
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
            onTapCreateMyMedicineButton: creactMyMedicineButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.resultMedicine.asObservable()
            .do(onNext: { [weak self] in self?.noFoundVStackView.isHidden = !$0.isEmpty })
            .bind(to: resultTableView.rx.items(
                cellIdentifier: SearchResultTableCell.identifier,
                cellType: SearchResultTableCell.self
            )) { _, data, cell in
                cell.setup(data)
            }
            .disposed(by: disposeBag)

        searchController.searchBar.rx.text.asObservable()
            .do(onNext: { [weak self] _ in self?.noFoundVStackView.isHidden = true })
            .map {
                guard let name = $0, !name.isEmpty else { return "" }
                return "\"\(name)\"를 찾을 수 없음"
            }
            .bind(to: notFoundMainLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
