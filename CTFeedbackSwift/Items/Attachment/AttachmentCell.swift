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
        static let Margin:               CGFloat = 15.0
    }

    private var eventHandler: AttachmentCellEventProtocol!
    private var item:         AttachmentItem?

    private let attachmentImageView = UIImageView()
    private var attachmentImageViewHeightConstraint: NSLayoutConstraint?
    private var attachmentImageViewWidthConstraint:  NSLayoutConstraint?

    private let attachmentLabel = UILabel()
    private var attachmentLabelLeadingWithImageViewConstraint:       NSLayoutConstraint?
    private var attachmentLabelLeadingWithContentViewViewConstraint: NSLayoutConstraint?

    private let tapImageViewGestureRecognizer = UITapGestureRecognizer()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        attachmentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(attachmentImageView)
        attachmentImageView.isUserInteractionEnabled = true
        attachmentImageViewHeightConstraint = attachmentImageView.heightAnchor
            .constraint(equalToConstant: Const.NoAttachedCellHeight)
        attachmentImageViewHeightConstraint?.isActive = true
        contentView.topAnchor.constraint(equalTo: attachmentImageView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: attachmentImageView.bottomAnchor).isActive = true
        attachmentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                     constant: Const.Margin).isActive = true
        attachmentImageViewWidthConstraint = attachmentImageView.widthAnchor
            .constraint(equalToConstant: 0.0)
        attachmentImageViewWidthConstraint?.isActive = true
        attachmentImageView.addGestureRecognizer(tapImageViewGestureRecognizer)
        tapImageViewGestureRecognizer.addTarget(self, action: #selector(imageViewTapped(_:)))

        attachmentLabel.translatesAutoresizingMaskIntoConstraints = false
        attachmentLabel.numberOfLines = 0
        contentView.addSubview(attachmentLabel)
        attachmentLabel.adjustsFontSizeToFitWidth = true
        attachmentLabelLeadingWithImageViewConstraint
        = attachmentLabel.leadingAnchor.constraint(equalTo: attachmentImageView.trailingAnchor,
                                                   constant: Const.Margin)
        attachmentLabelLeadingWithContentViewViewConstraint
        = attachmentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Const.Margin)
        contentView.trailingAnchor.constraint(equalTo: attachmentLabel.trailingAnchor,
                                              constant: 0.0).isActive = true
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
                cell.attachmentLabelLeadingWithContentViewViewConstraint?.isActive = false
                cell.attachmentLabelLeadingWithImageViewConstraint?.isActive = true
            } else {
                cell.attachmentImageViewWidthConstraint?.constant = 0.0
                cell.attachmentLabelLeadingWithImageViewConstraint?.isActive = false
                cell.attachmentLabelLeadingWithContentViewViewConstraint?.isActive = true
            }
        }
        cell.eventHandler = eventHandler
    }
}
