// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Model

import RxFlow

final class ReceiptOcrFlow: Flow {

    let appDI: AppDI
    let presentable: ReceiptOcrViewController

    var root: Presentable { presentable }

    init(appDI: AppDI) {
        self.appDI = appDI
        self.presentable = ReceiptOcrViewController(viewModel: appDI.receiptOcrViewModel)
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .receiptOcrIsRequired:
            return reqiredReceiptOcrVC()
        default:
            return .none
        }
    }

    private func reqiredReceiptOcrVC() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: presentable,
            withNextStepper: presentable.viewModel
        ))
    }
}
