//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

func CTLocalizedString(_ key: String) -> String {
    let bundles: [Bundle] = [Bundle.main, Bundle.feedbackBundle]
    for bundle in bundles {
        let string = NSLocalizedString(key, bundle: bundle, comment: "")
        if !string.isEmpty { return string }
    }
    return "key"
}
