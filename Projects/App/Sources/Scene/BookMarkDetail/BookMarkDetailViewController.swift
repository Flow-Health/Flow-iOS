import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class BookMarkDetailViewController: BaseVC<BookMarkDetailViewModel> {
    private let resultTableView = UITableView().then {
        $0.backgroundColor = .black6
        $0.register(BookMarkResultTableCell.self, forCellReuseIdentifier: BookMarkResultTableCell.identifier)
        $0.rowHeight = 120
        $0.keyboardDismissMode = .onDrag
    }

    override func attridute() {
        navigationItem.title = "자주 먹는 약"
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

    override func bind() {
        let input = BookMarkDetailViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            selectedItemIndex: resultTableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.bookMarkList.asObservable()
            .bind(to: resultTableView.rx.items(
                cellIdentifier: BookMarkResultTableCell.identifier,
                cellType: BookMarkResultTableCell.self
            )) { _, data, cell in
                cell.setup(data)
            }
            .disposed(by: disposeBag)
    }
}
