//
//  Pack.swift
//  Manifests
//
//  Created by 강동영 on 6/25/25.
//

import ProjectDescription

let packageSettings: PackageSettings = .make(
    productTypes: [
        SPM.TCA: .framework,
        SPM.FirebaseAnalytics : .framework,
        SPM.FirebaseAnalyticsSwift : .framework,
        SPM.FirebaseDatabase : .framework,
        SPM.FirebaseDatabaseSwift : .framework,
        SPM.protoc : .framework,
        SPM.Realm : .framework,
        SPM.RealmSwift : .framework,
        SPM.SwiftProtobuf : .framework,
        SPM.SwiftProtobufPluginLibrary : .framework,
    ]
)
