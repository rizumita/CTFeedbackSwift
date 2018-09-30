//
// Created by 和泉田 領一 on 2017/09/22.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

public enum Media: Equatable {
    var jpegData: Data? {
        guard case let .image(image) = self else { return .none }
        return image.jpegData(compressionQuality: 0.5)
    }
    var videoData: Data? {
        guard case let .video(_, url) = self else { return .none }
        return try? Data(contentsOf: url)
    }
    case image(UIImage)
    case video(UIImage, URL)

    public static func ==(lhs: Media, rhs: Media) -> Bool {
        switch (lhs, rhs) {
        case (.image(let lImage), .image(let rImage)):
            return lImage == rImage
        case (.video(_, let lUrl), .video(_, let rUrl)):
            return lUrl == rUrl
        default:
            return false
        }
    }
}
