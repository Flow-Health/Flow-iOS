// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import RxFlow

final class HomeFlow: Flow {

    let appDI: AppDI
    let presentable = UINavigationController()

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
}
