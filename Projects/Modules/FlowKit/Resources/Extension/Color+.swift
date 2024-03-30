import UIKit
import SwiftUI

// MARK: - for UIkit UIColor
public extension UIColor {
    static let black2 = FlowKitAsset.black2.color
    static let black3 = FlowKitAsset.black3.color
    static let black4 = FlowKitAsset.black4.color
    static let black5 = FlowKitAsset.black5.color
    static let black6 = FlowKitAsset.black6.color

    static let blue1 = FlowKitAsset.blue1.color
    static let blue2 = FlowKitAsset.blue2.color
    static let blue3 = FlowKitAsset.blue3.color
    static let blue4 = FlowKitAsset.blue4.color
    static let blue5 = FlowKitAsset.blue5.color

    static let green1 = FlowKitAsset.green1.color
    static let green2 = FlowKitAsset.green2.color
    static let green3 = FlowKitAsset.green3.color
    static let green4 = FlowKitAsset.green4.color

    static let red1 = FlowKitAsset.red1.color
    static let red2 = FlowKitAsset.red2.color
    static let red3 = FlowKitAsset.red3.color
    static let red4 = FlowKitAsset.red4.color
}

// MARK: - for SwiftUI Color
public extension Color {
    static let black2 = FlowKitAsset.black2.swiftUIColor
    static let black3 = FlowKitAsset.black3.swiftUIColor
    static let black4 = FlowKitAsset.black4.swiftUIColor
    static let black5 = FlowKitAsset.black5.swiftUIColor
    static let black6 = FlowKitAsset.black6.swiftUIColor

    static let blue1 = FlowKitAsset.blue1.swiftUIColor
    static let blue2 = FlowKitAsset.blue2.swiftUIColor
    static let blue3 = FlowKitAsset.blue3.swiftUIColor
    static let blue4 = FlowKitAsset.blue4.swiftUIColor
    static let blue5 = FlowKitAsset.blue5.swiftUIColor

    static let green1 = FlowKitAsset.green1.swiftUIColor
    static let green2 = FlowKitAsset.green2.swiftUIColor
    static let green3 = FlowKitAsset.green3.swiftUIColor
    static let green4 = FlowKitAsset.green4.swiftUIColor

    static let red1 = FlowKitAsset.red1.swiftUIColor
    static let red2 = FlowKitAsset.red2.swiftUIColor
    static let red3 = FlowKitAsset.red3.swiftUIColor
    static let red4 = FlowKitAsset.red4.swiftUIColor
}

// MARK: - for SwiftUI ShapeStyle
public extension ShapeStyle where Self == Color {
    static var black2: Color { FlowKitAsset.black2.swiftUIColor }
    static var black3: Color { FlowKitAsset.black3.swiftUIColor }
    static var black4: Color { FlowKitAsset.black4.swiftUIColor }
    static var black5: Color { FlowKitAsset.black5.swiftUIColor }
    static var black6: Color { FlowKitAsset.black6.swiftUIColor }

    static var blue1: Color { FlowKitAsset.blue1.swiftUIColor }
    static var blue2: Color { FlowKitAsset.blue2.swiftUIColor }
    static var blue3: Color { FlowKitAsset.blue3.swiftUIColor }
    static var blue4: Color { FlowKitAsset.blue4.swiftUIColor }
    static var blue5: Color { FlowKitAsset.blue5.swiftUIColor }

    static var green1: Color { FlowKitAsset.green1.swiftUIColor }
    static var green2: Color { FlowKitAsset.green2.swiftUIColor }
    static var green3: Color { FlowKitAsset.green3.swiftUIColor }
    static var green4: Color { FlowKitAsset.green4.swiftUIColor }

    static var red1: Color { FlowKitAsset.red1.swiftUIColor }
    static var red2: Color { FlowKitAsset.red2.swiftUIColor }
    static var red3: Color { FlowKitAsset.red3.swiftUIColor }
    static var red4: Color { FlowKitAsset.red4.swiftUIColor }
}
