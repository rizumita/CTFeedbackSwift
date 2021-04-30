//
//  BodyCell.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/16.
//  Copyright © 2017年 CAPH TECH. All rights reserved.
//

import UIKit

protocol BodyCellEventProtocol {
    func bodyCellHeightChanged()
    func bodyTextDidChange(_ text: String?)
}

class BodyCell: UITableViewCell {
    var eventHandler: BodyCellEventProtocol?

    let textView: UITextView = {
        let result = UITextView(frame: CGRect.zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.isScrollEnabled = false
        result.font = .systemFont(ofSize: 14.0)
        result.backgroundColor = .clear
        return result
    }()
    
    let placeholederLabel: UILabel = {
        let result = UILabel()
        result.text = CTLocalizedString("CTFeedback.BodyPlaceholder")
        result.font = .systemFont(ofSize: 14.0)
        result.numberOfLines = 1
        result.isUserInteractionEnabled = false
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    var heightConstraint: NSLayoutConstraint?

    var height: CGFloat {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width,
                                                height: CGFloat.greatestFiniteMagnitude))
        return max(100.0, size.height)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textView.delegate = self
        contentView.addSubview(textView)
        contentView.addSubview(placeholederLabel)
        contentView.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: -12.0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12.0).isActive = true
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.priority = .defaultHigh
        heightConstraint?.isActive = true
        
        contentView.topAnchor.constraint(
            equalTo: placeholederLabel.topAnchor,
            constant: -8.0
        ).isActive = true
        
        contentView.leadingAnchor.constraint(
            equalTo: placeholederLabel.leadingAnchor,
            constant: -16.0
        ).isActive = true
        
        contentView.trailingAnchor.constraint(
            equalTo: placeholederLabel.trailingAnchor,
            constant: -16.0
        ).isActive = true
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}

extension BodyCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholederLabel.isHidden = !textView.text.isEmpty
        heightConstraint?.constant = height
        eventHandler?.bodyCellHeightChanged()
        eventHandler?.bodyTextDidChange(textView.text)
    }
}

extension BodyCell: CellFactoryProtocol {
    static func configure(_ cell: BodyCell,
                          with item: BodyItem,
                          for indexPath: IndexPath,
                          eventHandler: BodyCellEventProtocol) {
        cell.textView.text = item.bodyText
        cell.selectionStyle = .none
        cell.eventHandler = eventHandler
    }
}
