import WidgetKit

struct TimeCheckWidgetEntry: TimelineEntry {
    var date: Date

    var lastTakenTime: Date?
    var lastEatingMedicine: [(name: String, id: String)]?
}
