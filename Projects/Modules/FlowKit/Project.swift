import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "FlowKit",
    dependencies: [
        .Module.core
    ]
)
