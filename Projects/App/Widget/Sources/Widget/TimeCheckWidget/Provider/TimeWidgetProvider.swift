import SwiftUI
import WidgetKit

struct TimeCheckWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimeCheckWidgetEntry {
        TimeCheckWidgetEntry(date: Date(), lastEatingTime: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimeCheckWidgetEntry) -> Void) {
        let entry = TimeCheckWidgetEntry(
            date: Date(),
            lastEatingTime: Date(),
            lastEatingMedicine: nil
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimeCheckWidgetEntry>) -> Void) {
        let entries: [TimeCheckWidgetEntry] = [
            .init(date: Date(), lastEatingTime: Date(), lastEatingMedicine: nil)
        ]
        completion(.init(entries: entries, policy: .never))
    }
}
