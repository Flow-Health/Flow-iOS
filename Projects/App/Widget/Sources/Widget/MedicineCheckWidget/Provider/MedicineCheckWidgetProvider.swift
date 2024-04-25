import WidgetKit
import FlowService

import RxSwift

struct MedicineCheckWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MedicineCheckEntry {
        .init(date: .now, targetMedicine: .placeholderData)
    }

    func snapshot(for configuration: MedicineCheckIntent, in context: Context) async -> MedicineCheckEntry {
        .init(date: .now, targetMedicine: configuration.selectedMedicine)
    }
    
    func timeline(for configuration: MedicineCheckIntent, in context: Context) async -> Timeline<MedicineCheckEntry> {
        let lastTakenTime = await getLastTakenTime()

        return .init(
            entries: [
                .init(
                    date: .now, 
                    lastTakenTime: lastTakenTime,
                    targetMedicine: configuration.selectedMedicine
                )
            ],
            policy: .never)
    }
}

extension MedicineCheckWidgetProvider {
    private func getLastTakenTime() async -> Date? {
        let disposeBag = DisposeBag()
        let service = ServiceDI.resolve()

        let lastTakenTime = await withCheckedContinuation { continuation in
            service.fetchMedicineRecodeUseCase.execute()
                .subscribe(onSuccess: {
                    continuation.resume(returning: $0?.lastTakenTime)
                })
                .disposed(by: disposeBag)
        }
        return lastTakenTime
    }
}
