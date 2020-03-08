//
//  SystemVersionCell.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/24.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit

class SystemVersionCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension SystemVersionCell: CellFactoryProtocol {
    class func configure(_ cell: SystemVersionCell,
                         with item: SystemVersionItem,
                         for indexPath: IndexPath,
                         eventHandler: Any?) {
        #if targetEnvironment(macCatalyst)
            cell.textLabel?.text = "macOS"
        #else
            cell.textLabel?.text = CTLocalizedString("CTFeedback.iOS")
        #endif
        cell.detailTextLabel?.text = item.version
        cell.selectionStyle = .none
    }
}
