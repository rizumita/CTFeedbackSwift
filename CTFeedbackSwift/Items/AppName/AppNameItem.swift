//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

struct AppNameItem: FeedbackItemProtocol {
    var name: String {
        if let result = _name {
            return result
        }
        if let displayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return displayName
        }
        if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        return ""
    }
    
    private var _name: String?

    let isHidden: Bool

    init(isHidden: Bool, name: String? = nil) {
        self.isHidden = isHidden
        self._name = name
    }
}
