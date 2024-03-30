import SwiftUI
import WidgetKit

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
            MedicineCheckHeaderView(contentText: entry.targetMedicine)
            Spacer()
            Toggle(isOn: true, intent: RecordMedicineIntent(recordData: entry.targetMedicine)) {
                VStack(alignment: .center, spacing: 0) {
                    Rectangle().frame(height: 0)
                    Text("기록하기")
//                        .font(.captionC1SemiBold)
                        .foregroundStyle(.white)
                }
            }
            .tint(.clear)
//            .background(.blue3)
            .cornerRadius(10)
        }
        .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
    }
}

struct MediumMedicineCheckWidgetView: View {
    let entry: MedicineCheckWidgetProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            MedicineCheckHeaderView(contentText: entry.targetMedicine)
            Spacer()
            HStack(alignment: .bottom) {
                LastMedicineTimeView(lastTakenDate: Date())
                Spacer()
                Toggle(isOn: true, intent: RecordMedicineIntent(recordData: entry.targetMedicine)) {
                    VStack(alignment: .center) {
                        Text("기록하기")
//                            .font(.captionC1SemiBold)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 82)
                }
                .tint(.clear)
//                .background(.blue3)
                .cornerRadius(10)
            }
        }
        .padding(EdgeInsets(top: 15, leading: 14, bottom: 15, trailing: 14))
    }
}

