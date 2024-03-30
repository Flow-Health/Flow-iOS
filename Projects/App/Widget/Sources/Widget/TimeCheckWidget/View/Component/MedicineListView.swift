import SwiftUI
import FlowKit

struct MedicineListView: View {
    let headerText: String
    let medicineList: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(headerText)
                .font(.captionC1SemiBold)
                .foregroundStyle(.black)
            ForEach(medicineList, id: \.self) { name in
                MedicineListCell(content: name)
            }
        }
    }
}

#Preview {
    MedicineListView(
        headerText: "복용약",
        medicineList: ["뉴스피린장용정100밀리그램", "아스피린", "프로포폴"]
    )
}
