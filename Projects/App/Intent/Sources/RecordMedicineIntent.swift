import SwiftUI
import AppIntents
import WidgetKit
import FlowService
import Model
import Core

import RxSwift


struct RecordMedicineIntent: AppIntent {

    static var title: LocalizedStringResource = "약 기록 인텐트"

    @Parameter(title: "medicineItemCode")
    var medicineItemCode: String?

    init() {}

    init(medicineItemCode: String?) {
        self.medicineItemCode = medicineItemCode
    }

    func perform() async throws -> some IntentResult {
        await recodeMedicine(itemCode: medicineItemCode)
        return .result()
    }
}

extension RecordMedicineIntent {
    func recodeMedicine(itemCode: String?) async {
        guard let itemCode = medicineItemCode else { return }
        let disposeBag = DisposeBag()
        let service = ServiceDI.resolve()
        let recodeDate = Date()

        await withCheckedContinuation { continuation in
            service.insertTakenMedicineUseCase.execute(with: itemCode, at: recodeDate)
                .subscribe(onCompleted: {
                    LocalNotificationHelper.shared.pushNotification(
                        title: "약 기록하기 📝",
                        body: "약을 기록하였습니다. (\(recodeDate.toString(.nomal)))",
                        seconds: 0.5,
                        identifier: "COMPLITED_RECODE"
                    )
                    continuation.resume()
                }, onError: {
                    LocalNotificationHelper.shared.pushNotification(
                        title: "⚠️ ERROR",
                        body: "복용약 기록을 실패하였습니다. (error: \($0.localizedDescription)",
                        seconds: 1,
                        identifier: "COMPLITED_RECODE_ERROR"
                    )
                    continuation.resume()
                })
                .disposed(by: disposeBag)
        }
    }
}
