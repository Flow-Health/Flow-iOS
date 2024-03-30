import WidgetKit
import SwiftUI
import AppIntents

struct MedicineCheckWidget: Widget {
    private let kind = "flow.widget.MedicineCheckWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: MedicineCheckIntent.self,
            provider: MedicineCheckWidgetProvider()
        ) { entry in
            MedicineCheckWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("약 기록")
        .description("원하는 약을 선택하여 기록할 수 있습니다.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
