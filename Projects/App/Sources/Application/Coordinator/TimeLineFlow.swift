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
        self.presentable = TimeLineDetailViewController(viewModel: appDI.makeTimeLineDetailViewModel())
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .timeLineDetailIsRequired:
            return reqiredTimeLineVC()
        case .timeLineSettingIsRequired(let date):
            return navigateToTimeLineSettingVC(date)
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

    private func navigateToTimeLineSettingVC(_ date: Date) -> FlowContributors {
        let timeLineSettingVC = TimeLineSettingViewController(viewModel: appDI.makeTimeLineSettingViewModel())
        timeLineSettingVC.setUp(date: date)
        presentable.navigationController?.pushViewController(timeLineSettingVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: timeLineSettingVC,
            withNextStepper: timeLineSettingVC.viewModel
        ))
    }
}
