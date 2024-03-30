import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Core",
    dependencies: [
        .Module.thirdPartyLib
    ]
)
