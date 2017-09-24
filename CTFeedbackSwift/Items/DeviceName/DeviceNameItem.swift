//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public struct DeviceNameItem: FeedbackItemProtocol {
    var deviceName: String {
        guard let path = Bundle.platformNamesPlistPath,
              let dictionary = NSDictionary(contentsOfFile: path) as? [String : String]
            else { return "" }

        let rawPlatform = platform
        return dictionary[rawPlatform] ?? rawPlatform
    }

    private var platform: String {
        var mib: [Int32] = [CTL_HW, HW_MACHINE]
        var len: Int     = 2
        sysctl(&mib, 2, .none, &len, .none, 0)
        var machine = [CChar](repeating: 0, count: Int(len))
        sysctl(&mib, 2, &machine, &len, .none, 0)
        let result = String(cString: machine)
        return result
    }

    public let isHidden: Bool = false
}
