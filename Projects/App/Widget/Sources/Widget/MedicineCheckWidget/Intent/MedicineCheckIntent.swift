import AppIntents

import Model
import FlowService
import RxSwift

struct BookMarkMedicineAppEntity: AppEntity {
    var id: String
    var itemCode: String?
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "북마크한 약"
    static var defaultQuery = BookMarkMedicineQuery()
    
    static var placeholderData = BookMarkMedicineAppEntity(id: "placeholderData", itemCode: "")
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: itemCode != nil ? "\(id)" : "복용약을 선택해주세요.")
    }
}

struct BookMarkMedicineQuery: EntityQuery {

    func entities(for identifiers: [BookMarkMedicineAppEntity.ID]) async throws -> [BookMarkMedicineAppEntity] {
        let markData = try await suggestedEntities().filter { identifiers.contains($0.id) }
        return markData + [.init(id: "위젯을 길게 눌러 복용약을 선택해주세요")]
    }

    func suggestedEntities() async throws -> [BookMarkMedicineAppEntity] {
        let suggestedData = await withCheckedContinuation { continuation in
            getBookMarkAppEntity { continuation.resume(returning: $0) }
        }
        return suggestedData
    }

    func defaultResult() async -> BookMarkMedicineAppEntity? {
        .init(id: "위젯을 길게 눌러 복용약을 선택해주세요")
    }
}

extension BookMarkMedicineQuery {
    func getBookMarkAppEntity(
        complitionHeader: @escaping ([BookMarkMedicineAppEntity]) -> Void
    ) {
        let disposeBag = DisposeBag()
        let service = ServiceDI.resolve()

        service.fetchBookMarkMedicineListUseCase.execute()
            .map { $0.map { BookMarkMedicineAppEntity(id: $0.medicineName, itemCode: $0.itemCode) }}
            .subscribe(onSuccess: complitionHeader)
            .disposed(by: disposeBag)
     }
}

struct MedicineCheckIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "복용할 약을 설정합니다."
    
    @Parameter(title: "복용할 약")
    var selectedMedicine: BookMarkMedicineAppEntity
}
