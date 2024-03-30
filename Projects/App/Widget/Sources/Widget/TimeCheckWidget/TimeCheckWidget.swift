import WidgetKit
import SwiftUI

struct TimeCheckWidget: Widget {
    private let kind = "flow.widget.TimeCheckWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: TimeCheckWidgetProvider()
        ) { entry in
            TimeCheckWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("기록 확인")
        .description("복용 기록을 확인할 수 있습니다.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
