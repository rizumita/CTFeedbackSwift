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
    public var hasAttachedMedia: Bool {
        guard let item = editingItemsRepository.item(of: AttachmentItem.self) else { return false }
        return item.media != .none
    }

    public func update(bodyText: String?) {
        guard var item = editingItemsRepository.item(of: BodyItem.self) else { return }
        item.bodyText = bodyText
        editingItemsRepository.set(item: item)
    }

    public func fetchTopics() -> [TopicProtocol] {
        guard let item = editingItemsRepository.item(of: TopicItem.self) else { return [] }
        return item.topics
    }

    public func update(selectedTopic: TopicProtocol) {
        guard var item = editingItemsRepository.item(of: TopicItem.self) else { return }
        item.selected = selectedTopic
        guard let indexPath = editingItemsRepository.set(item: item) else { return }
        feedbackEditingEventHandler.updated(at: indexPath)
    }

    public func update(attachmentMedia: Media?) {
        guard var item = editingItemsRepository.item(of: AttachmentItem.self) else { return }
        item.media = attachmentMedia
        guard let indexPath = editingItemsRepository.set(item: item) else { return }
        feedbackEditingEventHandler.updated(at: indexPath)
    }
}
