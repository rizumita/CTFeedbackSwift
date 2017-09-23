//
// Created by 和泉田 領一 on 2017/09/09.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public protocol FeedbackEditingEventProtocol {
    func updated(at indexPath: IndexPath)
}

public protocol FeedbackEditingServiceProtocol {
    var hasAttachedMedia: Bool { get }
    func update(bodyText: String?)
    func fetchTopics() -> [TopicProtocol]
    func update(selectedTopic: TopicProtocol)
    func update(attachmentMedia: Media?)
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
    public var hasAttachedMedia: Bool { return editingItemsRepository.attachmentMedia != .none }

    public func update(bodyText: String?) {
        editingItemsRepository.bodyText = bodyText
    }

    public func fetchTopics() -> [TopicProtocol] { return topicsRepository.topics }

    public func update(selectedTopic: TopicProtocol) {
        editingItemsRepository.selectedTopic = selectedTopic
        guard let indexPath = editingItemsRepository.indexPath(of: TopicItem.self)
            else { return }
        feedbackEditingEventHandler.updated(at: indexPath)
    }

    public func update(attachmentMedia: Media?) {
        editingItemsRepository.attachmentMedia = attachmentMedia
        guard let indexPath = editingItemsRepository.indexPath(of: AttachmentItem.self)
            else { return }
        feedbackEditingEventHandler.updated(at: indexPath)
    }
}
