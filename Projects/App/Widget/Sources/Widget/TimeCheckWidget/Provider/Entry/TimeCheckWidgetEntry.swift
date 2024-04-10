import WidgetKit

struct TimeCheckWidgetEntry: TimelineEntry {
    var date: Date

    var lastEatingTime: Date?
    var lastEatingMedicine: [(name: String, id: String)]?
}
