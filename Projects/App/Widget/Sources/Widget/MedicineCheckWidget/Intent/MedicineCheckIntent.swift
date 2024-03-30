import AppIntents

struct MedicineCheckIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "복용할 약을 설정합니다."

    @Parameter(title: "복용할 약", default: "아스피린")
    var selectedMedicine: String
}
