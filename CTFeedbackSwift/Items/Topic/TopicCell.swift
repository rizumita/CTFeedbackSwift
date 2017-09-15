//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

public class TopicCell: UITableViewCell {
    public static var reuseIdentifier: String { return "TopicCell" }

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: TopicCell.reuseIdentifier)
    }

    public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}
