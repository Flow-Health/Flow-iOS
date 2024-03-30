import WidgetKit

struct MedicineCheckWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MedicineCheckEntry {
        return .init(date: Date(), targetMedicine: "hello!")
    }

    func snapshot(for configuration: MedicineCheckIntent, in context: Context) async -> MedicineCheckEntry {
        .init(date: Date(), targetMedicine: configuration.selectedMedicine)
    }
    
    func timeline(for configuration: MedicineCheckIntent, in context: Context) async -> Timeline<MedicineCheckEntry> {
        return .init(entries: [.init(date: Date(), targetMedicine: configuration.selectedMedicine)], policy: .never)
    }
}
