//
// Created by 和泉田 領一 on 2017/09/18.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

struct AttachmentItem: FeedbackItemProtocol {
    var attached: Bool { return media != .none }
    var media:    Media?
    var image:    UIImage? {
        switch media {
        case .image(let i)?:    return i
        case .video(let i, _)?: return i
        default:                return .none
        }
    }
    let isHidden: Bool

    init(isHidden: Bool) { self.isHidden = isHidden }
}
