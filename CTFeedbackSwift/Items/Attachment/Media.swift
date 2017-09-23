//
// Created by 和泉田 領一 on 2017/09/22.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

public enum Media: Equatable {
    case image(UIImage)
    case movie(UIImage, URL)

    public static func ==(lhs: Media, rhs: Media) -> Bool {
        switch (lhs, rhs) {
        case (.image(let lImage), .image(let rImage)):
            return lImage == rImage
        case (.movie(let lImage, let lUrl), .movie(let rImage, let rUrl)):
            return lUrl == rUrl
        default:
            return false
        }
    }
}
