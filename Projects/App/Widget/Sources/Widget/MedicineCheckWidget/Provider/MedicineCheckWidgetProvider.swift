import WidgetKit

struct MedicineCheckWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MedicineCheckEntry {
        .init(date: .now, targetMedicine: .placeholderData)
    }

    func snapshot(for configuration: MedicineCheckIntent, in context: Context) async -> MedicineCheckEntry {
        .init(date: .now, targetMedicine: configuration.selectedMedicine)
    }
    
    func timeline(for configuration: MedicineCheckIntent, in context: Context) async -> Timeline<MedicineCheckEntry> {
        return .init(
            entries: [
                .init(date: .now, targetMedicine: configuration.selectedMedicine)
            ],
            policy: .never)
    }
}
