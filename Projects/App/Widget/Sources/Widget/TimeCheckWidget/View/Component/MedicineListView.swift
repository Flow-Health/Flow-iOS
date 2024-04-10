import SwiftUI
import FlowKit

struct MedicineListView: View {
    let headerText: String
    let medicineList: [(name: String, id: String)]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(headerText)
                .font(.captionC1SemiBold)
                .foregroundStyle(.black)
            ForEach(medicineList, id: \.id) {
                MedicineListCell(content: $0.name)
            }
        }
    }
}
