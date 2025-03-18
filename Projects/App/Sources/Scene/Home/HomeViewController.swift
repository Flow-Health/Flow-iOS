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
    private lazy var scrollView = VScrollView(
        isRefreshAble: true,
        refreshAction: { self.viewWillAppearRelay.accept(()) }
    )

    private let headerView = HomeHeaderView()
    private let LastTakenBannerView = LastTakenTimeView()
    private let PillGramADBannerButton = PillGramADBanner();
    private let searchButtonView = SearchButtonView()
    private let bookMarkMedicineView = BookMarkMedicineView()
    private let timeLineView = TimeLineView()
    private let appInfoButtonView = AppInfoButton()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func attridute() {
        view.backgroundColor = .blue5
    }

    override func addView() {
        view.addSubview(scrollView)
        scrollView.contentView.addSubViews(
            headerView,
            homeVStaek
        )
        homeVStaek.addArrangedSubviews(
            PillGramADBannerButton,
            LastTakenBannerView,
            searchButtonView,
            bookMarkMedicineView,
            timeLineView,
            appInfoButtonView
        )
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.trailing.leading.equalToSuperview()
        }
        scrollView.contentView.snp.makeConstraints {
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

    override func bind() {
        let input = HomeViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            tapSearchButton: searchButtonView.rx.tap.asObservable(),
            tapBookMarkNavigationButton: bookMarkMedicineView.headerButton.rx.tap.asObservable(),
            tapTimeLineNavigationButton: timeLineView.headerView.rx.tap.asObservable(),
            tapAppInfoButton: appInfoButtonView.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.bookMarkList
            .drive(onNext: bookMarkMedicineView.addBookMarkMedicine(_:))
            .disposed(by: disposeBag)

        output.timeLineList
            .drive(onNext: timeLineView.addTimeLine(_:))
            .disposed(by: disposeBag)

        output.lastTakenTime
            .drive(onNext: LastTakenBannerView.setLastTime(_:))
            .disposed(by: disposeBag)
        
        PillGramADBannerButton.rx.tap
            .subscribe(onNext: {
                let fillgramURL = URL(string: "https://pillgram.kr/Promotion/PackageLanding.aspx?promotionId=EA2E8E27-69B7-405C-B076-C4A488ED22A0&utm_source=flow&utm_medium=event")!
                if (UIApplication.shared.canOpenURL(fillgramURL)) {
                    UIApplication.shared.open(fillgramURL)
                }
            })
            .disposed(by: disposeBag)
    }
}
