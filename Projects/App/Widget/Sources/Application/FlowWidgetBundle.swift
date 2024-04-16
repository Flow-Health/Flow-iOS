import WidgetKit
import SwiftUI

@main
struct FlowWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimeCheckWidget()
        MedicineCheckWidget()
    }
}
