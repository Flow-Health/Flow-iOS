//
//  FlowWidgetBundle.swift
//  FlowWidget
//
//  Created by 조병진 on 3/13/24.
//

import WidgetKit
import SwiftUI

@main
struct FlowWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimeCheckWidget()
        MedicineCheckWidget()
//        FlowWidgetLiveActivity()
    }
}
