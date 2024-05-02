// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Model

import RxFlow

final class TimeLineFlow: Flow {

    let appDI: AppDI
    let presentable: TimeLineDetailViewController

    var root: Presentable { presentable }

    init(appDI: AppDI) {
        self.appDI = appDI
        self.presentable = TimeLineDetailViewController(viewModel: appDI.timeLineDetailViewModel)
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .timeLineDetailIsRequired:
            return reqiredTimeLineVC()
        default:
            return .none
        }
    }

    private func reqiredTimeLineVC() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: presentable,
            withNextStepper: presentable.viewModel
        ))
    }
}
