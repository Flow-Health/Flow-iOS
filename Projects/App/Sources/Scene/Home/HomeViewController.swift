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
    private let infoNavigateButton = InfoNavigateButton()

    private let homeVStaek = VStack(spacing: 10)
    private let appendButtonBundle = HStack(spacing: 10).then {
        $0.distribution = .fillEqually
    }
    private lazy var scrollView = VScrollView(
        isRefreshAble: true,
        refreshAction: { [weak self] in
            self?.viewWillAppearRelay.accept(())
        }
    )

    private let LastTakenBannerView = LastTakenTimeView()
    private let searchButtonView = SearchButtonView()
    private let reciptButtonView = ReceiptOcrButtonView()
    private let bookMarkMedicineView = BookMarkMedicineView()
    private let timeLineView = TimeLineView()

    override func attridute() {
        view.backgroundColor = .blue5
        navigationItem.title = "홈"
        navigationItem.titleView = UIView()
        navigationItem.leftBarButtonItem = .init(customView: logoImageView).applyHidesSharedBackground()
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
            timeLineView
        )
    }

    override func setAutoLayout() {
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
            tapBookMarkNavigationButton: bookMarkMedicineView.rx.tapGesture().when(.ended).map { _ in }.asObservable(),
            tapTimeLineNavigationButton: timeLineView.rx.tapGesture().when(.ended).map { _ in }.asObservable(),
            tapAppInfoButton: infoNavigateButton.tap.asObservable()
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
    }
}
