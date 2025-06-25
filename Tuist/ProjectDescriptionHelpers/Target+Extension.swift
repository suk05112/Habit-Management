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
        sources: SourceFilesList? = ["Sources/**"],
        resources: ResourceFileElements? = ["Resources/**"],
        dependencies: [Module]
    ) -> Target {
        
        return .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: bundleId,
            sources: sources,
            resources: resources,
            dependencies: dependencies.asTargetDependencies()
        )
    }
}
