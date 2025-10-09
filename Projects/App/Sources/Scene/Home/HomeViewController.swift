import UIKit
import FlowKit
import Core
import Model

import SnapKit
import Then
import RxSwift
import RxCocoa

class HomeViewController: BaseVC<HomeViewModel> {

    private let logoImageView = UIImageView().then {
        $0.image = FlowKitAsset.logoText.image
    }
    private let infoNavigateButton = UIBarButtonItem().then {
        $0.image = FlowKitAsset.settingGear.image
        $0.tintColor = .black.withAlphaComponent(0.7)
        $0.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    }

    private let homeVStaek = VStack(spacing: 10)
    private let appendButtonBundle = HStack(spacing: 10).then {
        $0.distribution = .fillEqually
    }
    private lazy var scrollView = VScrollView(
        isRefreshAble: true,
        refreshAction: { self.viewWillAppearRelay.accept(()) }
    )

    private let LastTakenBannerView = LastTakenTimeView()
    private let PillGramADBannerButton = PillGramADBanner()
    private let searchButtonView = SearchButtonView()
    private let reciptButtonView = ReceiptOcrButtonView()
    private let bookMarkMedicineView = BookMarkMedicineView()
    private let timeLineView = TimeLineView()

    override func attridute() {
        view.backgroundColor = .blue5
        navigationItem.leftBarButtonItem = .init(customView: logoImageView)
        navigationItem.rightBarButtonItem = infoNavigateButton
    }

    override func addView() {
        view.addSubview(scrollView)
        scrollView.contentView.addSubViews(
            homeVStaek
        )
        appendButtonBundle.addArrangedSubviews(
            reciptButtonView,
            searchButtonView
        )
        homeVStaek.addArrangedSubviews(
            LastTakenBannerView,
            appendButtonBundle,
            bookMarkMedicineView,
            timeLineView,
            PillGramADBannerButton
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
        homeVStaek.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    override func bind() {
        let input = HomeViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            tapSearchButton: searchButtonView.rx.tap.asObservable(),
            tapOcrButton: reciptButtonView.rx.tap.asObservable(),
            tapBookMarkNavigationButton: bookMarkMedicineView.headerButton.rx.tap.asObservable(),
            tapTimeLineNavigationButton: timeLineView.headerView.rx.tap.asObservable(),
            tapAppInfoButton: infoNavigateButton.rx.tap.asObservable()
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
