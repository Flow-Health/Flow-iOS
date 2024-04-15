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
    }
    private let searchBar = SearchBarController()

    override func attridute() {
        navigationItem.searchController = searchBar
        navigationItem.title = "약 검색"
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }

    override func addView() {
        view.addSubview(resultTableView)
    }

    override func setLayout() {
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.bottom.equalToSuperview()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableCell.identifier, for: indexPath) as? SearchResultTableCell else { return UITableViewCell() }
        cell.setup(.init(imageURL: "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/153339721554900111", medicineName: "뉴스피린장용정100밀리그램", companyName: "뉴스피린(주)", itemCode: "320314213", efficacy: "", howToUse: "", cautionWarning: "", caution: "", interaction: "", sideEffect: "", storageMethod: "", updateDate: Date()))
        return cell
    }
}
