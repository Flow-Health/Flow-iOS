import Foundation
import FlowService
import Model

struct AppDI {
    let homeViewModel: HomeViewModel
    let searchViewModel: SearchViewModel
    let receiptOcrScanViewModel: ReceiptOcrScanViewModel
    let receiptOcrResultViewModel: ReceiptOcrResultViewModel
    let receiptOcrEndViewModel: ReceiptOcrEndViewModel
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
        let receiptOcrScanViewModelInject = ReceiptOcrScanViewModel(
            searchMedicineWithOcrUseCase: serviceDI.searchMedicineWithOcrUseCase
        )
        let receiptOcrResultViewModelInject = ReceiptOcrResultViewModel(
            insertBookMarkMedicineUseCase: serviceDI.insertBookMarkMedicineUseCase,
            findBookMarkMedicineUseCase: serviceDI.findBookMarkMedicineUseCase
        )
        let receiptOcrEndViewModelInject = ReceiptOcrEndViewModel()
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
        let medicineRegisterViewModelInject = MedicineRegisterViewModel(
            registerMyMedicineUseCase: serviceDI.registerMyMedicineUseCase
        )

        return .init(
            homeViewModel: homeViewModelInject,
            searchViewModel: searchViewModelInject,
            receiptOcrScanViewModel: receiptOcrScanViewModelInject,
            receiptOcrResultViewModel: receiptOcrResultViewModelInject,
            receiptOcrEndViewModel: receiptOcrEndViewModelInject,
            medicineDetailViewModel: medicineDetailViewModelInject,
            bookMarkDetailViewModel: bookMarkDetailViewModelInject,
            timeLineDetailViewModel: timeLineDetailViewModelInject,
            appInfoViewModel: appInfoViewModelInject,
            medicineRegisterViewModel: medicineRegisterViewModelInject
        )
    }
}
