import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Model",
    dependencies: [
        .Module.core
    ]
)
