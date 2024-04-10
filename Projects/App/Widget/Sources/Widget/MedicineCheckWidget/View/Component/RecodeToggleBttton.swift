// Copyright © 2024 com.flow-health. All rights reserved.

import SwiftUI
import AppIntents

import FlowKit

struct RecodeToggleBttton: View {

    let isDisabled: Bool
    let itemCode: String?

    var body: some View {
        Toggle(
            isOn: true,
            intent: RecordMedicineIntent(medicineItemCode: itemCode)
        ) {
            VStack(alignment: .center, spacing: 0) {
                Rectangle().frame(height: 0)
                Text("기록하기")
                    .font(.captionC1SemiBold)
                    .foregroundStyle(.white)
            }
        }
        .disabled(isDisabled)
        .tint(.clear)
        .background(isDisabled ? .black4 : .blue3)
        .cornerRadius(10)
    }
}
