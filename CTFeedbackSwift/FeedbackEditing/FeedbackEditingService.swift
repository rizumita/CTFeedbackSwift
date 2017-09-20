//
// Created by 和泉田 領一 on 2017/09/09.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public protocol FeedbackEditingEventProtocol {
    func selectedTopicUpdated()
}

public protocol FeedbackEditingServiceProtocol {
    func update(bodyText: String?)
    func fetchTopics() -> [TopicProtocol]
    func updateSelectedTopic(_ topic: TopicProtocol)
}

public class FeedbackEditingService {
    let topicsRepository:            TopicsRepositoryProtocol
    var editingItemsRepository:      FeedbackEditingItemsRepositoryProtocol
    let feedbackEditingEventHandler: FeedbackEditingEventProtocol

    public init(topicsRepository: TopicsRepositoryProtocol,
                editingItemsRepository: FeedbackEditingItemsRepositoryProtocol,
                feedbackEditingEventHandler: FeedbackEditingEventProtocol) {
        self.topicsRepository = topicsRepository
        self.editingItemsRepository = editingItemsRepository
        self.feedbackEditingEventHandler = feedbackEditingEventHandler
    }
}

extension FeedbackEditingService: FeedbackEditingServiceProtocol {
    public func update(bodyText: String?) {
        editingItemsRepository.bodyText = bodyText
    }

    public func fetchTopics() -> [TopicProtocol] { return topicsRepository.topics }

    public func updateSelectedTopic(_ topic: TopicProtocol) {
        editingItemsRepository.selectedTopic = topic
        feedbackEditingEventHandler.selectedTopicUpdated()
    }
}
