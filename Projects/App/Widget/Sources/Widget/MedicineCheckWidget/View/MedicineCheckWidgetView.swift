import SwiftUI
import WidgetKit
import FlowKit

struct MedicineCheckWidgetEntryView: View {

    @Environment(\.widgetFamily) var widgetFamily
    private let entry: MedicineCheckWidgetProvider.Entry

    init(entry: MedicineCheckWidgetProvider.Entry) {
        self.entry = entry
    }

    var body: some View {
        widgetBody()
            .containerBackground(.white, for: .widget)
    }

    @ViewBuilder
    func widgetBody() -> some View {
        switch widgetFamily {
        case .systemSmall:
            SmallMedicineCheckWidgetView(entry: entry)
        case .systemMedium:
            MediumMedicineCheckWidgetView(entry: entry)
        default:
            EmptyView()
        }
    }
}

struct SmallMedicineCheckWidgetView: View {
    let entry: MedicineCheckWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            MedicineCheckHeaderView(contentText: entry.targetMedicine.id)
            Spacer()
            RecodeToggleBttton(
                isDisabled: entry.targetMedicine.itemCode == nil,
                itemCode: entry.targetMedicine.itemCode
            )
        }
        .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(hex: entry.targetMedicine.itemHexCode ?? "#FFFFFF") ?? .clear, lineWidth: 12)
        }
    }
}

struct MediumMedicineCheckWidgetView: View {
    let entry: MedicineCheckWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            MedicineCheckHeaderView(contentText: entry.targetMedicine.id)
            Spacer()
            HStack(alignment: .bottom) {
                LastMedicineTimeView(lastTakenDate: entry.date)
                Spacer()
                RecodeToggleBttton(
                    isDisabled: entry.targetMedicine.itemCode == nil,
                    itemCode: entry.targetMedicine.itemCode
                )
                .frame(width: 86)
            }
        }
        .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(hex: entry.targetMedicine.itemHexCode ?? "#FFFFFF") ?? .clear, lineWidth: 12)
        }
    }
}

