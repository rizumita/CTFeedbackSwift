//
// Created by 和泉田 領一 on 2017/09/18.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

protocol AttachmentCellEventProtocol {
    func showImage(of item: AttachmentItem)
}

class AttachmentCell: UITableViewCell {
    private struct Const {
        static let NoAttachedCellHeight: CGFloat = 44.0
        static let AttachedCellHeight:   CGFloat = 65.0
        static let LeadingMargin:        CGFloat = 10.0
    }

    private var eventHandler: AttachmentCellEventProtocol!
    private var item:         AttachmentItem?

    private let attachmentImageView = UIImageView()
    private var attachmentImageViewHeightConstraint: NSLayoutConstraint?
    private var attachmentImageViewWidthConstraint:  NSLayoutConstraint?

    private let attachmentLabel = UILabel()

    private let tapImageViewGestureRecognizer = UITapGestureRecognizer()

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        attachmentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(attachmentImageView)
        attachmentImageView.isUserInteractionEnabled = true
        attachmentImageViewHeightConstraint = attachmentImageView.heightAnchor
            .constraint(equalToConstant: Const.NoAttachedCellHeight)
        attachmentImageViewHeightConstraint?.isActive = true
        contentView.topAnchor.constraint(equalTo: attachmentImageView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: attachmentImageView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: attachmentImageView.leadingAnchor,
                                             constant: Const.LeadingMargin)
        attachmentImageViewWidthConstraint = attachmentImageView.widthAnchor
            .constraint(equalToConstant: 0.0)
        attachmentImageViewWidthConstraint?.isActive = true
        attachmentImageView.addGestureRecognizer(tapImageViewGestureRecognizer)
        tapImageViewGestureRecognizer.addTarget(self, action: #selector(imageViewTapped(_:)))

        attachmentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(attachmentLabel)
        attachmentLabel.textAlignment = .right
        attachmentLabel.adjustsFontSizeToFitWidth = true
        attachmentImageView.trailingAnchor.constraint(equalTo: attachmentLabel.leadingAnchor,
                                                      constant: 8.0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: attachmentLabel.trailingAnchor,
                                              constant: 8.0).isActive = true
        contentView.centerYAnchor.constraint(equalTo: attachmentLabel.centerYAnchor).isActive = true
        attachmentLabel.text = CTLocalizedString("CTFeedback.AttachImageOrVideo")

        accessoryType = .disclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
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
        if let heightConstraint = cell.attachmentImageViewHeightConstraint {
            heightConstraint.constant = item.attached ? Const.AttachedCellHeight : Const.NoAttachedCellHeight

            if let image = cell.imageView?.image {
                cell.attachmentImageViewWidthConstraint?.constant = image.size.width
                                                                    * heightConstraint.constant
                                                                    / image.size.height
            } else {
                cell.attachmentImageViewWidthConstraint?.constant = 0.0
            }
        }
        cell.eventHandler = eventHandler
    }
}
