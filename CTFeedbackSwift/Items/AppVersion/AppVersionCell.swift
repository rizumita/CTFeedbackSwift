//
//  AppVersionCell.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/24.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit

class AppVersionCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension AppVersionCell: CellFactoryProtocol {
    class func configure(_ cell: AppVersionCell,
                         with item: AppVersionItem,
                         for indexPath: IndexPath,
                         eventHandler: Any?) {
        cell.textLabel?.text = CTLocalizedString("CTFeedback.Version")
        cell.detailTextLabel?.text = item.version
        cell.selectionStyle = .none
    }
}
