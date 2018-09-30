//
//  UserEmailCell.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/24.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit

protocol UserEmailCellEventProtocol {
    func userEmailTextDidChange(_ text: String?)
}

class UserEmailCell: UITableViewCell {
    private struct Const {
        static let FontSize: CGFloat = 14.0
        static let Margin:   CGFloat = 15.0
        static let Height:   CGFloat = 44.0
    }

    private var eventHandler: UserEmailCellEventProtocol!

    let textField = UITextField()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        textField.backgroundColor = .clear
        textField.delegate = self
        textField.placeholder = CTLocalizedString("CTFeedback.Mail")
        textField.keyboardType = .emailAddress
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: Const.Margin).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: Const.Margin).isActive = true
        textField.heightAnchor.constraint(equalToConstant: Const.Height).isActive = true
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension UserEmailCell: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        eventHandler.userEmailTextDidChange(textField.text)
        return true
    }
}

extension UserEmailCell: CellFactoryProtocol {
    class func configure(_ cell: UserEmailCell,
                         with item: UserEmailItem,
                         for indexPath: IndexPath,
                         eventHandler: UserEmailCellEventProtocol) {
        cell.eventHandler = eventHandler
    }
}
