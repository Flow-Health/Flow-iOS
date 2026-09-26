import Foundation
import FlowService
import Model

/// 앱의 Composition Root.
///
/// - `ServiceDI`(UseCase / Repository / DataSource)는 상태가 없으므로 앱 수명 동안 하나만 유지합니다.
/// - ViewModel은 화면(ViewController)과 생명주기를 같이하도록 `make*` 팩토리 메서드로 매번 새로 생성합니다.
///   ViewModel을 싱글턴으로 보관하면 화면 진입마다 `transform`의 구독이 누적되어 해제되지 않으므로,
///   Flow는 화면을 만들 때마다 팩토리를 호출해야 합니다.
struct AppDI {
    private let serviceDI: ServiceDI

    /// 앱 시작 시 1회만 생성되는 홈 화면의 ViewModel
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
