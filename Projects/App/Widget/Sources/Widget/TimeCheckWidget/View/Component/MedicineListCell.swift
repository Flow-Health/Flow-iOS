import SwiftUI
import FlowKit

struct MedicineListCell: View {
    let content: String

    var body: some View {
        HStack {
            Spacer().frame(width: 9)
            Text(content)
                .font(.captionC2Medium)
                .foregroundStyle(.blue1)
        }
        .overlay {
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 4)
                    .foregroundStyle(.blue2)
                Spacer()
            }
        }
    }
}

#Preview {
    MedicineListCell(content: "뉴스피린장용정100밀리그램")
}
