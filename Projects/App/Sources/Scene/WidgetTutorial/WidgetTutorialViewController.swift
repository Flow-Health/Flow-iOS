// Copyright © 2026 com.flow-health. All rights reserved.

import UIKit
import FlowKit
import Core

import SnapKit
import Then
import RxSwift
import RxCocoa

class WidgetTutorialViewController: BaseVC<WidgetTutorialViewModel> {

    private let pageScrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
    }
    private let pageStack = HStack()
    private let pageControl = UIPageControl().then {
        $0.pageIndicatorTintColor = .black5
        $0.currentPageIndicatorTintColor = .blue1
        $0.isUserInteractionEnabled = false
    }
    private let nextButton = FlowNextButton(title: "다음")

    override func attribute() {
        navigationItem.title = "위젯 추가 방법"
    }

    override func addView() {
        view.addSubViews(
            pageScrollView,
            pageControl,
            nextButton
        )
        pageScrollView.addSubview(pageStack)
    }

    override func setAutoLayout() {
        pageScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(pageControl.snp.top).offset(-8)
        }
        pageStack.snp.makeConstraints {
            $0.edges.equalTo(pageScrollView.contentLayoutGuide)
            $0.height.equalTo(pageScrollView.frameLayoutGuide)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(22)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func setAutoLayoutAfterLayoutSubviews() {
        nextButton.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
                .inset(view.safeAreaInsets.bottom > 0 ? 0 : 10)
        }
    }

    override func bind() {
        let currentPage = pageScrollView.rx.contentOffset
            .withUnretained(pageScrollView)
            .filter { scrollView, _ in scrollView.bounds.width > 0 }
            .map { scrollView, offset in Int((offset.x / scrollView.bounds.width).rounded()) }

        let input = WidgetTutorialViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable(),
            currentPage: currentPage,
            tapNextButton: nextButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.tutorialSteps
            .drive(with: self, onNext: { owner, steps in
                owner.setPages(steps)
            })
            .disposed(by: disposeBag)

        output.currentPage
            .drive(pageControl.rx.currentPage)
            .disposed(by: disposeBag)

        output.isLastPage
            .map { $0 ? "완료" : "다음" }
            .drive(nextButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        output.moveToPage
            .emit(with: self, onNext: { owner, page in
                let offsetX = owner.pageScrollView.bounds.width * CGFloat(page)
                owner.pageScrollView.setContentOffset(.init(x: offsetX, y: 0), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setPages(_ steps: [WidgetTutorialStep]) {
        pageControl.numberOfPages = steps.count
        steps.forEach { step in
            let pageView = WidgetTutorialPageView(step: step)
            pageStack.addArrangedSubview(pageView)
            pageView.snp.makeConstraints {
                $0.width.equalTo(pageScrollView.frameLayoutGuide)
            }
        }
    }
}
