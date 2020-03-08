//
// Created by 和泉田 領一 on 2017/09/25.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

struct FeedbackGenerator {
    static func generate(configuration: FeedbackConfiguration,
                         repository: FeedbackEditingItemsRepositoryProtocol) throws -> Feedback {
        guard let deviceName = repository.item(of: DeviceNameItem.self)?.deviceName,
              let systemVersion = repository.item(of: SystemVersionItem.self)?.version
            else { throw CTFeedbackError.unknown }
        let appName    = repository.item(of: AppNameItem.self)?.name ?? ""
        let appVersion = repository.item(of: AppVersionItem.self)?.version ?? ""
        let appBuild   = repository.item(of: AppBuildItem.self)?.buildString ?? ""
        let email      = repository.item(of: UserEmailItem.self)?.email
        let topic      = repository.item(of: TopicItem.self)?.selected
        let attachment = repository.item(of: AttachmentItem.self)?.media
        let body       = repository.item(of: BodyItem.self)?.bodyText ?? ""

        let subject = configuration.subject ?? generateSubject(appName: appName, topic: topic)

        let format        = configuration.usesHTML ? generateHTML : generateString
        let formattedBody = format(body,
                                   deviceName,
                                   systemVersion,
                                   appName,
                                   appVersion,
                                   appBuild,
                                   configuration.additionalDiagnosticContent)

        return Feedback(email: email,
                        to: configuration.toRecipients,
                        cc: configuration.ccRecipients,
                        bcc: configuration.bccRecipients,
                        subject: subject,
                        body: formattedBody,
                        isHTML: configuration.usesHTML,
                        jpeg: attachment?.jpegData,
                        mp4: attachment?.videoData)
    }

    private static func generateSubject(appName: String, topic: TopicProtocol?) -> String {
        return String(format: "%@: %@", appName, topic?.title ?? "")
    }

    private static func generateHTML(body: String,
                                     deviceName: String,
                                     systemVersion: String,
                                     appName: String,
                                     appVersion: String,
                                     appBuild: String,
                                     additionalDiagnosticContent: String?) -> String {
        var platform = "iOS"
        #if targetEnvironment(macCatalyst)
            platform="macOS"
        #endif
        let format          = """
        <style>td {padding-right: 20px}</style>
 <p>%@</p><br />
 <table cellspacing=0 cellpadding=0>
 <tr><td>Device:</td><td><b>%@</b></td></tr>
 <tr><td>%@:</td><td><b>%@</b></td></tr>
 <tr><td>App:</td><td><b>%@</b></td></tr>
 <tr><td>Version:</td><td><b>%@</b></td></tr>
 <tr><td>Build:</td><td><b>%@</b></td></tr>
 </table>
 """
        var content: String = String(format: format,
                                     body.replacingOccurrences(of: "\n", with: "<br />"),
                                     deviceName,
                                     platform,
                                     systemVersion,
                                     appName,
                                     appVersion,
                                     appBuild)
        if let additional = additionalDiagnosticContent { content.append(additional) }
        return content
    }

    private static func generateString(body: String,
                                       deviceName: String,
                                       systemVersion: String,
                                       appName: String,
                                       appVersion: String,
                                       appBuild: String,
                                       additionalDiagnosticContent: String?) -> String {
        var platform = "iOS"
        #if targetEnvironment(macCatalyst)
            platform="macOS"
        #endif
        var content: String
            = String(format: "%@\n\n\nDevice: %@\n%@: %@\nApp: %@\nVersion: %@\nBuild: %@",
                     body,
                     deviceName,
                     platform,
                     systemVersion,
                     appName,
                     appVersion,
                     appBuild)
        if let additional = additionalDiagnosticContent { content.append(additional) }
        return content
    }

}
