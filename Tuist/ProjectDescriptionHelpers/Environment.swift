import ProjectDescription

public enum Environment {
    public static let appName = "Habit Management"
    public static let targetName = ""
    public static let targetTestName = "\(targetName)Tests"
    public static let organizationName = "com.Habit-Management"
    public static let deploymentTarget: DeploymentTargets = .iOS("15.2")
    public static let destinations = Destinations.iOS
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
}
