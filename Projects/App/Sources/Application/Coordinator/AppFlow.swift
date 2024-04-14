// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit

import RxFlow

final class AppFlow: Flow {

    private let appDI: AppDI
    private let presentable: UIWindow

    var root: Presentable {
        self.presentable
    }

    init(appDI: AppDI, presentable: UIWindow) {
        self.appDI = appDI
        self.presentable = presentable
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .homeIsRequired:
            return useHomeFlow()
            
        default:
            return .none
        }
    }

    private func useHomeFlow() -> FlowContributors {
        let homeFlow = HomeFlow(appDI: appDI)
        Flows.use(homeFlow, when: .created) { [weak self] root in
            self?.presentable.rootViewController = root
        }

        return .one(flowContributor: .contribute(
            withNextPresentable: homeFlow,
            withNextStepper: OneStepper(withSingleStep: FlowStep.homeIsRequired)
        ))
    }
}
