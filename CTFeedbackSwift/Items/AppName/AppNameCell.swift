//
//  AppNameCell.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/24.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit

class AppNameCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension AppNameCell: CellFactoryProtocol {
    class func configure(_ cell: AppNameCell,
                         with item: AppNameItem,
                         for indexPath: IndexPath,
                         eventHandler: Any?) {
        cell.textLabel?.text = CTLocalizedString("CTFeedback.Name")
        cell.detailTextLabel?.text = item.name
        cell.selectionStyle = .none
    }
}
