//
//  AppIntent.swift
//  Habit Management
//
//  Created by 서충원 on 5/18/25.
//

import WidgetKit
import AppIntents

enum GrassTheme: String, AppEnum {
    case classic, dark, light, colorful

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Theme"

    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .classic: "Classic",
        .dark: "Dark",
        .light: "Light",
        .colorful: "Colorful"
    ]
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "잔디 테마를 선택하세요." }

    @Parameter(title: "Theme", default: .classic)
    var theme: GrassTheme
}
