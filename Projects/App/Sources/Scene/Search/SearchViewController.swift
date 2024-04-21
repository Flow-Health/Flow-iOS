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
    private let notFoundLabel = UILabel().then {
        $0.textColor = .black2
        $0.font = .bodyB1Medium
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isHidden = true
        $0.isUserInteractionEnabled = false
    }
    private let searchController = SearchBarController()

    override func attridute() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "약 검색"
    }

    override func addView() {
        view.addSubview(resultTableView)
        resultTableView.addSubview(notFoundLabel)
    }

    override func setLayout() {
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.bottom.equalToSuperview()
        }
        notFoundLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
        }
    }

    override func bind() {
        let input = SearchViewModel.Input(
            searchInputText: searchController.searchBar.searchTextField.rx.text.orEmpty.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.resultMedicine.asObservable()
            .do(onNext: { [weak self] in self?.notFoundLabel.isHidden = !$0.isEmpty })
            .bind(to: resultTableView.rx.items(
                cellIdentifier: SearchResultTableCell.identifier,
                cellType: SearchResultTableCell.self
            )) { _, data, cell in
                cell.setup(data)
            }
            .disposed(by: disposeBag)

        searchController.searchBar.rx.text.asObservable()
            .do(onNext: { [weak self] _ in self?.notFoundLabel.isHidden = true })
            .map {
                guard let name = $0, !name.isEmpty else { return "" }
                return "\"\(name)\"이 들어간 약을 찾을 수 없습니다."
            }
            .bind(to: notFoundLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
