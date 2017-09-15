//
// Created by 和泉田 領一 on 2017/09/08.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

public protocol TopicsDelegateProtocol: class {
    func topicWasSelected(_ topic: TopicProtocol)
}

public protocol TopicsSelectorProtocol {
    func selectTopics(topics: [TopicProtocol], delegate: TopicsDelegateProtocol)
}

extension FeedbackViewController: TopicsSelectorProtocol {
    public func selectTopics(topics: [TopicProtocol], delegate: TopicsDelegateProtocol) {
        let controller = TopicsViewController(topics: topics)
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
}