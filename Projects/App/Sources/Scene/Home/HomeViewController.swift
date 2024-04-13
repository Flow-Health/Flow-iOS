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

    private let headerView = HomeHeaderView()
    private let LastTakenBannerView = LastTakenTimeView()
    private let searchButtonView = SearchButtonView()
    private let bookMarkMedicineView = BookMarkMedicineView(isNavigatAble: true)
    private let timeLineView = TimeLineView()

    override func attridute() {
        view.backgroundColor = .blue5
    }

    override func addView() {
        view.addSubViews(
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
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        homeVStaek.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
}
