import Foundation
import FlowService
import Model

struct AppDI {
    let homeViewModel: HomeViewModel
    let searchViewModel: SearchViewModel
    let medicineDetailViewModel: MedicineDetailViewModel
}

extension AppDI {
    static func resolve() -> AppDI {
        let serviceDI = ServiceDI.resolve()

        let homeViewModelInject = HomeViewModel(
            fetchMedicineRecodeUseCase: serviceDI.fetchMedicineRecodeUseCase,
            fetchTakenMedicineListUseCase: serviceDI.fetchTakenMedicineListUseCase,
            fetchBookMarkMedicineListUseCase: serviceDI.fetchBookMarkMedicineListUseCase
        )

        let searchViewModelInject = SearchViewModel(
            searchMedicineUseCase: serviceDI.searchMedicineUseCase
        )
        let medicineDetailViewModelInject = MedicineDetailViewModel()

        return .init(
            homeViewModel: homeViewModelInject,
            searchViewModel: searchViewModelInject,
            medicineDetailViewModel: medicineDetailViewModelInject
        )
    }
}
