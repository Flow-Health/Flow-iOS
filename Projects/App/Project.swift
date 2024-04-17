import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "FlowApp",
    organizationName: flowOrganizationName,
    settings: .settings(base: .codeSign),
    targets: [
        .target(
            name: "FlowApp",
            destinations: .iOS,
            product: .app,
            bundleId: "\(flowOrganizationName).flow-App",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: uiKitPlist),
            sources: [
                "Sources/**",
                "Intent/Sources/**"
            ],
            resources: ["Resources/**"],
            entitlements: .file(path: "Entitlements/FlowApp.entitlements"),
            dependencies: [
                .Module.flowKit,
                .Module.flowService,
                .target(name: "FlowWidgetExtension", condition: .none)
            ]
        ),
        .target(
            name: "FlowWidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(flowOrganizationName).flow-App.flowWidget-Extension",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: widgetPlist),
            sources: [
                "Widget/Sources/**",
                "Intent/Sources/**"
            ],
            entitlements: .file(path: "Widget/Entitlements/FlowWidgetExtension.entitlements"),
            dependencies: [
                .Module.flowKit,
                .Module.flowService
            ]
        )
    ],
    fileHeaderTemplate: "___COPYRIGHT___"
)
