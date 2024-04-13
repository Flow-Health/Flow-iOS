import SwiftUI
import WidgetKit
import FlowKit

struct TimeCheckWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    private let entry: TimeCheckWidgetProvider.Entry
    
    init(entry: TimeCheckWidgetProvider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        wigetBody()
            .containerBackground(.white, for: .widget)
    }
    
    @ViewBuilder
    func wigetBody() -> some View {
        switch widgetFamily {
        case .systemSmall:
            SmallTimeCheckWidgetView(entry: entry)
            
        case .systemMedium:
            MediumTimeCheckWidgetView(entry: entry)
            
        default:
            EmptyView()
        }
    }
}

struct SmallTimeCheckWidgetView: View {
    let entry: TimeCheckWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle().frame(height: 0)
            TimeCheckWidgetHeaderView(contentText: entry.lastEatingTime?.toString(.nomal) ?? "--:--")
            Spacer().frame(height: 10)
            MedicineListView(
                headerText: "복용약",
                medicineList: entry.lastEatingMedicine ?? [
                    (name: "복용한 약이 없습니다.", id: "")
                ]
            )
            Spacer()
        }
        .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
    }
}

struct MediumTimeCheckWidgetView: View {
    let entry: TimeCheckWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle().frame(height: 0)
            TimeCheckWidgetHeaderView(contentText: entry.lastEatingTime?.toString(.nomal) ?? "--:--")
            Spacer()
            MedicineListView(
                headerText: "복용약",
                medicineList: entry.lastEatingMedicine ?? [
                    (name: "복용한 약이 없습니다.", id: "")
                ]
            )
            Spacer()
        }
        .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
    }
}
