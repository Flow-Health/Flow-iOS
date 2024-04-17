import ProjectDescription

extension SettingsDictionary {
    public static let codeSign = SettingsDictionary()
        .codeSignIdentityAppleDevelopment()
        .automaticCodeSigning(devTeam: "Z25H7B85Z8")
}
