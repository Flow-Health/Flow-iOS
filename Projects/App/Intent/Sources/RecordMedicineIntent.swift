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
                .subscribe(onCompleted: { continuation.resume() })
                .disposed(by: disposeBag)
        }

        await withCheckedContinuation { continuation in
            service.findBookMarkMedicineUseCase.execute(with: itemCode)
                .subscribe(onSuccess: {
                    if let info = $0 {
                        LocalNotificationHelper.shared.pushNotification(
                            title: "약 기록하기 📝",
                            body: "\(info.medicineName)을 기록하였습니다. (\(recodeDate.description))", // TODO: fix date format
                            seconds: 1,
                            identifier: "COMPLITED_RECODE"
                        )
                    } else {
                        LocalNotificationHelper.shared.pushNotification(
                            title: "⚠️ ERROR",
                            body: "복용약 기록을 실패하였습니다.",
                            seconds: 1,
                            identifier: "COMPLITED_RECODE"
                        )
                    }
                    continuation.resume()
                })
                .disposed(by: disposeBag)
        }

        
    }
}
