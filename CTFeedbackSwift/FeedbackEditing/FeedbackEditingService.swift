//
// Created by 和泉田 領一 on 2017/09/09.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public protocol FeedbackEditingServiceProtocol {
    func selectTopic(selector: TopicsSelectorProtocol)
}

public class FeedbackEditingService {
    let topicsRepository:       TopicsRepositoryProtocol
    var editingItemsRepository: FeedbackEditingItemsRepositoryProtocol

    public init(topicsRepository: TopicsRepositoryProtocol,
                editingItemsRepository: FeedbackEditingItemsRepositoryProtocol) {
        self.topicsRepository = topicsRepository
        self.editingItemsRepository = editingItemsRepository
    }
}

extension FeedbackEditingService: FeedbackEditingServiceProtocol {
    public func selectTopic(selector: TopicsSelectorProtocol) {
        selector.selectTopics(topics: topicsRepository.topics, delegate: self)
    }
}

extension FeedbackEditingService: TopicsDelegateProtocol {
    public func topicWasSelected(_ topic: TopicProtocol) {
        editingItemsRepository.selectedTopic = topic
    }
}
