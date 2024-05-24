// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import RxFlow
import FlowKit

final class HomeFlow: Flow {

    let appDI: AppDI
    let presentable = BaseNavigationController()

    var root: Presentable { presentable }

    init(appDI: AppDI) {
        self.appDI = appDI
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .homeIsRequired:
            return navigateToHomeVC()
        case .searchIsRequired:
            return navigateToSearchVC()
        case .bookMarkIsRequired:
            return navigateToBookMarkVC()
        case .timeLineDetailIsRequired:
            return navigateToTimeLineVC()
        case .appInfoIsRequired:
            return navigateToAppInfoVC()
        default:
            return .none
        }
    }

    private func navigateToHomeVC() -> FlowContributors {
        let homeVC = HomeViewController(viewModel: appDI.homeViewModel)
        presentable.pushViewController(homeVC, animated: false)
        return .one(flowContributor: .contribute(
            withNextPresentable: homeVC,
            withNextStepper: homeVC.viewModel
        ))
    }

    private func navigateToSearchVC() -> FlowContributors {
        let searchFlow = SearchFlow(appDI: appDI)
        Flows.use(searchFlow, when: .created) { [weak self] root in
            self?.presentable.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: searchFlow,
            withNextStepper: OneStepper(withSingleStep: FlowStep.searchIsRequired)
        ))
    }

    private func navigateToBookMarkVC() -> FlowContributors {
        let bookMarkFlow = BookMarkFlow(appDI: appDI)
        Flows.use(bookMarkFlow, when: .created) { [weak self] root in
            self?.presentable.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: bookMarkFlow,
            withNextStepper: OneStepper(withSingleStep: FlowStep.bookMarkIsRequired)
        ))
    }

    private func navigateToTimeLineVC() -> FlowContributors {
        let timeLineFlow = TimeLineFlow(appDI: appDI)
        Flows.use(timeLineFlow, when: .created) { [weak self] root in
            self?.presentable.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(
            withNextPresentable: timeLineFlow,
            withNextStepper: OneStepper(withSingleStep: FlowStep.timeLineDetailIsRequired)
        ))
    }

    private func navigateToAppInfoVC() -> FlowContributors {
        let appInfoVC = AppInfoViewController(viewModel: appDI.appInfoViewModel)
        presentable.pushViewController(appInfoVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: appInfoVC,
            withNextStepper: appInfoVC.viewModel
        ))
    }
}
