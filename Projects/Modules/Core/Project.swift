import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Core",
    infoPlist: .extendingDefault(with: [
        "BASE_URL": "$(BASE_URL)",
        "OPEN_API_SERVICE_KEY": "$(OPEN_API_SERVICE_KEY)"
    ]),
    configurations: [
        .debug(name: .debug, xcconfig: .relativeToRoot("Projects/Configs/shared.xcconfig")),
        .release(name: .release, xcconfig: .relativeToRoot("Projects/Configs/shared.xcconfig"))
    ],
    dependencies: [
        .Module.thirdPartyLib
    ]
)
