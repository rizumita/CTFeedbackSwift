//
// Created by 和泉田 領一 on 2017/09/24.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

struct AppBuildItem: FeedbackItemProtocol {
    var buildString: String {
        guard let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return "" }
        return build
    }

    let isHidden: Bool

    init(isHidden: Bool) { self.isHidden = isHidden }
}
