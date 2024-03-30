import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "LocalService",
    dependencies: [
        .Module.model
    ]
)
