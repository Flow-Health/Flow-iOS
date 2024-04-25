import WidgetKit
import Model

struct MedicineCheckEntry: TimelineEntry {
    var date: Date

    var lastTakenTime: Date?
    var targetMedicine: BookMarkMedicineAppEntity
}
