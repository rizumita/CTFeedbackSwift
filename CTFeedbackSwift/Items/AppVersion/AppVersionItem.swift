//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

struct AppVersionItem: FeedbackItemProtocol {
    var version: String {
        guard let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            else { return "" }
        return shortVersion
    }

    let isHidden: Bool

    init(isHidden: Bool) { self.isHidden = isHidden }
}
