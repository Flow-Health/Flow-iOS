import SwiftUI
import WidgetKit
import FlowService

import RxSwift

var checkNum = 0

struct TimeCheckWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimeCheckWidgetEntry {
        TimeCheckWidgetEntry(date: Date(), lastEatingTime: Date(), lastEatingMedicine: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimeCheckWidgetEntry) -> Void) {
        let service = ServiceDI.resolve()
        let disposeBag = DisposeBag()
    
        service.fetchMedicineRecodeUseCase.execute()
            .map {
                TimeCheckWidgetEntry(
                    date: Date(),
                    lastEatingTime: $0?.lastTakenTime,
                    lastEatingMedicine: $0?.recentMedicineNameList
                )
            }
            .subscribe(onSuccess: completion)
            .disposed(by: disposeBag)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimeCheckWidgetEntry>) -> Void) {
        let service = ServiceDI.resolve()
        let disposeBag = DisposeBag()

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .minute, value: 2, to: currentDate)!

        service.fetchMedicineRecodeUseCase.execute()
            .map {
                [TimeCheckWidgetEntry(
                    date: entryDate,
                    lastEatingTime: $0?.lastTakenTime,
                    lastEatingMedicine: $0?.recentMedicineNameList
                )]
            }
            .subscribe(onSuccess: { completion(.init(entries: $0, policy: .atEnd)) })
            .disposed(by: disposeBag)
    }
}
/*
 스
 아
 스
 */
