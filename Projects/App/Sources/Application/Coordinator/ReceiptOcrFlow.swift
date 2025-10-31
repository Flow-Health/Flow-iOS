// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Model

import RxFlow

final class ReceiptOcrFlow: Flow {

    let appDI: AppDI
    let presentable: ReceiptOcrScanViewController

    var root: Presentable { presentable }

    init(appDI: AppDI) {
        self.appDI = appDI
        self.presentable = ReceiptOcrScanViewController(viewModel: appDI.receiptOcrScanViewModel)
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .receiptOcrIsRequired:
            return reqiredReceiptOcrVC()
        case .receiptOcrResultIsRequired(let ocrResult):
            return presentReceiptOcrResultVC(ocrResult)
        case .receiptOcrEndIsRequired:
            return presentReceiptOcrEndVC()
        case .homeIsRequired:
            return popToRoot()
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

    private func presentReceiptOcrResultVC(_ ocrResult: [MedicineInfoEntity]) -> FlowContributors {
        let receiptOcrResultVC = ReceiptOcrResultViewController(
            viewModel: appDI.receiptOcrResultViewModel,
            ocrResult: ocrResult
        )

        presentable.navigationController?.pushViewController(receiptOcrResultVC, animated: true)

        return .one(flowContributor: .contribute(
            withNextPresentable: receiptOcrResultVC,
            withNextStepper: receiptOcrResultVC.viewModel
        ))
    }

    private func presentReceiptOcrEndVC() -> FlowContributors {
        let receiptOcrEndVC = ReceiptOcrEndViewController(
            viewModel: appDI.receiptOcrEndViewModel
        )

        presentable.navigationController?.pushViewController(receiptOcrEndVC, animated: true)

        return .one(flowContributor: .contribute(
            withNextPresentable: receiptOcrEndVC,
            withNextStepper: receiptOcrEndVC.viewModel
        ))
    }

    private func popToRoot() -> FlowContributors {
        DispatchQueue.main.async { [weak self] in
            self?.presentable.navigationController?.popToRootViewController(animated: true)
        }

        return .none
    }
}
