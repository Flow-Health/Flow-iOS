import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "FlowService",
    dependencies: [
        .Module.remoteService,
        .Module.localService
    ]
)
