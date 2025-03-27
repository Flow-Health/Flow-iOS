// Copyright © 2024 com.flow-health. All rights reserved.

import UIKit
import Model

import RxFlow

final class BookMarkFlow: Flow {

    let appDI: AppDI
    let presentable: BookMarkDetailViewController

    var root: Presentable { presentable }

    init(appDI: AppDI) {
        self.appDI = appDI
        self.presentable = BookMarkDetailViewController(viewModel: appDI.bookMarkDetailViewModel)
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .bookMarkIsRequired:
            return reqiredBookMarkVC()
        case .madicineDetailIsRequired(let medicineInfo):
            return navigateToMedicineDetailVC(medicineInfo)
        case .createMyMedicineIsRequired:
            return presentMedicineRegister()
        default:
            return .none
        }
    }

    private func reqiredBookMarkVC() -> FlowContributors {
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
    
    private func presentMedicineRegister() -> FlowContributors {
        let medicineRegisterVC = MedicineRegisterViewController(viewModel: appDI.medicineRegisterViewModel)
        medicineRegisterVC.modalPresentationStyle = .fullScreen

        presentable.present(medicineRegisterVC, animated: true)

        return .one(flowContributor: .contribute(
            withNextPresentable: medicineRegisterVC,
            withNextStepper: medicineRegisterVC.viewModel
        ))
    }
}
