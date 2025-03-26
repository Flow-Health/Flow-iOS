import Foundation
import FlowService
import Model

struct AppDI {
    let homeViewModel: HomeViewModel
    let searchViewModel: SearchViewModel
    let medicineDetailViewModel: MedicineDetailViewModel
    let bookMarkDetailViewModel: BookMarkDetailViewModel
    let timeLineDetailViewModel: TimeLineDetailViewModel
    let appInfoViewModel: AppInfoViewModel
    let medicineRegisterViewModel: MedicineRegisterViewModel
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
        let medicineDetailViewModelInject = MedicineDetailViewModel(
            findBookMarkMedicineUseCase: serviceDI.findBookMarkMedicineUseCase,
            deleteBookMarkMedicineUseCase: serviceDI.deleteBookMarkMedicineUseCase,
            insertBookMarkMedicineUseCase: serviceDI.insertBookMarkMedicineUseCase,
            updateBookMarkMedicineUseCase: serviceDI.updateBookMarkMedicineUseCase
        )
        let bookMarkDetailViewModelInject = BookMarkDetailViewModel(
            fetchBookMarkMedicineListUseCase: serviceDI.fetchBookMarkMedicineListUseCase
        )
        let timeLineDetailViewModelInject = TimeLineDetailViewModel(
            fetchTakenMedicineListUseCase: serviceDI.fetchTakenMedicineListUseCase
        )
        let appInfoViewModelInject = AppInfoViewModel()
        let medicineRegisterViewModelInject = MedicineRegisterViewModel()

        return .init(
            homeViewModel: homeViewModelInject,
            searchViewModel: searchViewModelInject,
            medicineDetailViewModel: medicineDetailViewModelInject,
            bookMarkDetailViewModel: bookMarkDetailViewModelInject,
            timeLineDetailViewModel: timeLineDetailViewModelInject,
            appInfoViewModel: appInfoViewModelInject,
            medicineRegisterViewModel: medicineRegisterViewModelInject
        )
    }
}
