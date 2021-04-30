//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public struct DeviceNameItem: FeedbackItemProtocol {
    var deviceName: String {
        guard let path = Bundle.platformNamesPlistPath,
              let dictionary = NSDictionary(contentsOfFile: path) as? [String: String]
            else { return "" }

        let rawPlatform = platform
        return dictionary[rawPlatform] ?? rawPlatform
    }

    private var platform: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        guard let machine = withUnsafePointer(to: &systemInfo.machine, {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in
                String.init(validatingUTF8: ptr)
            }
        }) else { return "Unknown" }
        return String(validatingUTF8: machine) ?? "Unknown"
    }

    public let isHidden: Bool = false
}
