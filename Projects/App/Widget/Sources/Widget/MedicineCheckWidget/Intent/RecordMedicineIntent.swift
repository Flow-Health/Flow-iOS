import SwiftUI
import AppIntents

struct RecordMedicineIntent: AppIntent {
    static var title: LocalizedStringResource = "약 기록 인텐트"

    @Parameter(title: "recordIntent")
    var recordData: String

    init() {}

    init(recordData: String) {
        self.recordData = recordData
    }

    func perform() async throws -> some IntentResult {
        print(recordData)
        return .result()
    }
}
