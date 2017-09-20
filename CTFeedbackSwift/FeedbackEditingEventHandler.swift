//
// Created by 和泉田 領一 on 2017/09/17.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

class FeedbackEditingEventHandler: FeedbackEditingEventProtocol {
    weak var controller: FeedbackViewController?

    func selectedTopicUpdated() { controller?.tableView.reloadData() }
}
