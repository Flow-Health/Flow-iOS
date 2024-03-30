import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "FlowKit",
    resources: ["Resources/**"],
    dependencies: [
        .Module.core
    ]
)
