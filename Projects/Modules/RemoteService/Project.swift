import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "RemoteService",
    dependencies: [
        .Module.model
    ]
)
