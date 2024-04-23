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
    private let bookMarkEmptyView = EmptyStatusView(
        icon: FlowKitAsset.readingGlassesWithCloud.image,
        title: "등록된 약이 없습니다",
        subTitle: "약을 검색하여 자주 먹는\n약을 등록해보세요"
    )

    override func attridute() {
        navigationItem.title = "자주 먹는 약"
    }

    override func addView() {
        view.addSubViews(
            resultTableView,
            bookMarkEmptyView
        )
    }

    override func setLayout() {
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.bottom.equalToSuperview()
        }
        bookMarkEmptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(45)
        }
    }

    override func bind() {
        let input = BookMarkDetailViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            selectedItemIndex: resultTableView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.bookMarkList.asObservable()
            .do(onNext: { [weak self] in self?.bookMarkEmptyView.isHidden = !$0.isEmpty })
            .bind(to: resultTableView.rx.items(
                cellIdentifier: BookMarkResultTableCell.identifier,
                cellType: BookMarkResultTableCell.self
            )) { _, data, cell in
                cell.setup(data)
            }
            .disposed(by: disposeBag)
    }
}
