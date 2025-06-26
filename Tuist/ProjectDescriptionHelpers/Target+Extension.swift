//
//  Target+Extension.swift
//  ProjectDescriptionHelpers
//
//  Created by 강동영 on 6/25/25.
//

import ProjectDescription


public extension Target {
    static func makeModule(
        name: String,
        destinations: Destinations = Environment.destinations,
        product: Product = .app,
        bundleId: String,
        deploymentTargets: DeploymentTargets? = Environment.deploymentTarget,
        infoPlist: InfoPlist? = .extendingDefault(with: [
            "UILaunchStoryboardName": "LaunchScreen",
        ]),
        sources: SourceFilesList? = ["Sources/**"],
        resources: ResourceFileElements? = ["Resources/**"],
        
        dependencies: [Module] = []
    ) -> Target {
        
        return .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: bundleId,
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies.asTargetDependencies(),
            coreDataModels: [CoreDataModel.coreDataModel(.relativeToRoot("Projects/App/CoreData/Habit_Management.xcdatamodeld"))]
        )
    }
}
