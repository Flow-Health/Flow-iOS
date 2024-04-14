import Foundation
import FlowService
import Model

struct AppDI {
    let homeViewModel: HomeViewModel
}

extension AppDI {
    static func resolve() -> AppDI {
        let serviceDI = ServiceDI.resolve()

        let homeViewModelInject = HomeViewModel(
            fetchMedicineRecodeUseCase: serviceDI.fetchMedicineRecodeUseCase,
            fetchTakenMedicineListUseCase: serviceDI.fetchTakenMedicineListUseCase,
            fetchBookMarkMedicineListUseCase: serviceDI.fetchBookMarkMedicineListUseCase
        )

        return .init(
            homeViewModel: homeViewModelInject
        )
    }
}
