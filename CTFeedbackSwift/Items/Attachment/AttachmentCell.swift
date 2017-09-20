//
// Created by 和泉田 領一 on 2017/09/18.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

protocol AttachmentCellEventProtocol {
}

class AttachmentCell: UITableViewCell {
}

extension AttachmentCell: CellFactoryProtocol {
    static let reuseIdentifier: String = "AttachmentCell"

    class func configure(_ cell: AttachmentCell,
                         with item: AttachmentItem,
                         for indexPath: IndexPath,
                         eventHandler: AttachmentCellEventProtocol) {
    }
}
