import SwiftUI
import FlowKit

struct MedicineCheckHeaderView: View {
    let contentText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("복용할 약 💊")
                .font(.bodyB2SemiBold)
                .foregroundStyle(.black)
            Text(contentText)
                .font(.bodyB3Medium)
                .foregroundStyle(.blue1)
        }
    }
}

#Preview {
    MedicineCheckHeaderView(contentText: "보령아스트릭스캡슐100밀리그람(아스피린)")
}
