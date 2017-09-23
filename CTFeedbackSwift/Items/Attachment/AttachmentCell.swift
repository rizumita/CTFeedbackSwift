//
// Created by 和泉田 領一 on 2017/09/18.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

protocol AttachmentCellEventProtocol {
    func showImage(of item: AttachmentItem)
}

class AttachmentCell: UITableViewCell {
    private var eventHandler: AttachmentCellEventProtocol!
    private var item:         AttachmentItem?
    private let tapImageViewGestureRecognizer = UITapGestureRecognizer()

    override func awakeFromNib() {
        super.awakeFromNib()

        imageView?.addGestureRecognizer(tapImageViewGestureRecognizer)
        imageView?.isUserInteractionEnabled = true
        tapImageViewGestureRecognizer.addTarget(self, action: #selector(imageViewTapped(_:)))
    }
}

extension AttachmentCell {
    @objc func imageViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let item = item, item.image != .none else { return }
        eventHandler.showImage(of: item)
    }
}

extension AttachmentCell: CellFactoryProtocol {
    static let reuseIdentifier: String = "AttachmentCell"

    class func configure(_ cell: AttachmentCell,
                         with item: AttachmentItem,
                         for indexPath: IndexPath,
                         eventHandler: AttachmentCellEventProtocol) {
        cell.item = item
        cell.imageView?.image = item.image
        cell.eventHandler = eventHandler
    }
}
