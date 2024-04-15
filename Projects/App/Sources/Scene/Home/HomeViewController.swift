import UIKit
import FlowKit
import Core
import Model

import SnapKit
import Then
import RxSwift
import RxCocoa

class HomeViewController: BaseVC<HomeViewModel> {

    private let homeVStaek = VStack(spacing: 10)
    private let scrollView = VScrollView()

    private let headerView = HomeHeaderView()
    private let LastTakenBannerView = LastTakenTimeView()
    private let searchButtonView = SearchButtonView()
    private let bookMarkMedicineView = BookMarkMedicineView(isNavigatAble: true)
    private let timeLineView = TimeLineView()

    override func attridute() {
        view.backgroundColor = .blue5
        navigationController?.navigationBar.isHidden = true
    }

    override func addView() {
        view.addSubview(scrollView)
        scrollView.contentView.addSubViews(
            headerView,
            homeVStaek
        )
        homeVStaek.addArrangedSubviews(
            LastTakenBannerView,
            searchButtonView,
            bookMarkMedicineView,
            timeLineView
        )
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.trailing.leading.equalToSuperview()
        }
        scrollView.contentView.snp.makeConstraints {
            $0.top.bottom.width.equalToSuperview()
            $0.bottom.equalTo(homeVStaek)
        }
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        homeVStaek.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
}
