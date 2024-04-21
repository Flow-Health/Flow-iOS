// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Model

import RxFlow

final class SearchFlow: Flow {

    let appDI: AppDI
    let presentable: SearchViewController

    var root: Presentable { presentable }

    init(appDI: AppDI) {
        self.appDI = appDI
        self.presentable = SearchViewController(viewModel: appDI.searchViewModel)
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .searchIsRequired:
            return reqiredSearchVC()
        case .madicineDetailIsRequired(let medicineInfo):
            return navigateToMedicineDetailVC(medicineInfo)
        default:
            return .none
        }
    }

    private func reqiredSearchVC() -> FlowContributors {
        return .one(flowContributor: .contribute(
            withNextPresentable: presentable,
            withNextStepper: presentable.viewModel
        ))
    }

    private func navigateToMedicineDetailVC(_ entity: MedicineInfoEntity) -> FlowContributors {
        let medicineDetailVC = MedicineDetailViewController(viewModel: appDI.medicineDetailViewModel)
        medicineDetailVC.setUp(with: entity)
        presentable.navigationController?.pushViewController(medicineDetailVC, animated: true)
        return .one(flowContributor: .contribute(
            withNextPresentable: medicineDetailVC,
            withNextStepper: medicineDetailVC.viewModel
        ))
    }
}
