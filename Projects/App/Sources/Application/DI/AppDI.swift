import Foundation
import FlowService
import Model

/// ViewModel은 싱글턴으로 두면 transform 구독이 누적되므로 화면 생성 시마다 make*로 새로 만든다
struct AppDI {
    private let serviceDI: ServiceDI

    let homeViewModel: HomeViewModel

    private init(serviceDI: ServiceDI) {
        self.serviceDI = serviceDI
        self.homeViewModel = HomeViewModel(
            fetchMedicineRecodeUseCase: serviceDI.fetchMedicineRecodeUseCase,
            fetchTakenMedicineListUseCase: serviceDI.fetchTakenMedicineListUseCase,
            fetchBookMarkMedicineListUseCase: serviceDI.fetchBookMarkMedicineListUseCase
        )
    }

    static func resolve() -> AppDI {
        .init(serviceDI: ServiceDI.resolve())
    }
}

// MARK: - ViewModel Factory
extension AppDI {
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(
            searchMedicineUseCase: serviceDI.searchMedicineUseCase
        )
    }

    func makeReceiptOcrScanViewModel() -> ReceiptOcrScanViewModel {
        ReceiptOcrScanViewModel(
            searchMedicineWithOcrUseCase: serviceDI.searchMedicineWithOcrUseCase
        )
    }

    func makeReceiptOcrResultViewModel() -> ReceiptOcrResultViewModel {
        ReceiptOcrResultViewModel(
            insertBookMarkMedicineUseCase: serviceDI.insertBookMarkMedicineUseCase,
            findBookMarkMedicineUseCase: serviceDI.findBookMarkMedicineUseCase
        )
    }

    func makeReceiptOcrEndViewModel() -> ReceiptOcrEndViewModel {
        ReceiptOcrEndViewModel()
    }

    func makeMedicineDetailViewModel() -> MedicineDetailViewModel {
        MedicineDetailViewModel(
            findBookMarkMedicineUseCase: serviceDI.findBookMarkMedicineUseCase,
            deleteBookMarkMedicineUseCase: serviceDI.deleteBookMarkMedicineUseCase,
            insertBookMarkMedicineUseCase: serviceDI.insertBookMarkMedicineUseCase,
            updateBookMarkMedicineUseCase: serviceDI.updateBookMarkMedicineUseCase
        )
    }

    func makeBookMarkDetailViewModel() -> BookMarkDetailViewModel {
        BookMarkDetailViewModel(
            fetchBookMarkMedicineListUseCase: serviceDI.fetchBookMarkMedicineListUseCase
        )
    }

    func makeTimeLineDetailViewModel() -> TimeLineDetailViewModel {
        TimeLineDetailViewModel(
            fetchTakenMedicineListUseCase: serviceDI.fetchTakenMedicineListUseCase
        )
    }

    func makeTimeLineSettingViewModel() -> TimeLineSettingViewModel {
        TimeLineSettingViewModel(
            fetchTakenMedicineListUseCase: serviceDI.fetchTakenMedicineListUseCase,
            deleteTakenMedicineUseCase: serviceDI.deleteTakenMedicineUseCase
        )
    }

    func makeAppInfoViewModel() -> AppInfoViewModel {
        AppInfoViewModel()
    }

    func makeMedicineRegisterViewModel() -> MedicineRegisterViewModel {
        MedicineRegisterViewModel(
            registerMyMedicineUseCase: serviceDI.registerMyMedicineUseCase
        )
    }
}
