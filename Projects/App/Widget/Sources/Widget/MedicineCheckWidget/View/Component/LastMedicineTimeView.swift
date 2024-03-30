import SwiftUI
import FlowKit

struct LastMedicineTimeView: View {
    let lastTakenDate: Date

    var body: some View {
        HStack {
            Spacer().frame(width: 8)
            VStack(alignment: .leading, spacing: 2) {
                Text("마지막 복용시간")
                    .font(.captionC2Medium)
                    .foregroundStyle(.black3)
                Text("17:45 AM") // TODO: fix date formate
                    .font(.headerH3Bold)
                    .foregroundStyle(.black2)
            }
        }
        .overlay {
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 4)
                    .foregroundStyle(.black4)
                Spacer()
            }
        }
    }
}

#Preview {
    LastMedicineTimeView(lastTakenDate: Date())
}
