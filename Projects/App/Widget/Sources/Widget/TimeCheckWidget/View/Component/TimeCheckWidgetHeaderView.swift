import SwiftUI

struct TimeCheckWidgetHeaderView: View {
    let contentText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("마지막 복용시간")
//                .font(.captionC1SemiBold)
                .foregroundStyle(.black)
            Text(contentText)
//                .font(.headerH3Bold)
//                .foregroundStyle(.blue1)
        }
    }
}

#Preview {
    TimeCheckWidgetHeaderView(contentText: "17:15 AM")
}
