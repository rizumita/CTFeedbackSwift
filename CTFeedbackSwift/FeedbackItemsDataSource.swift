//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

public class FeedbackItemsDataSource {
    var sections: [FeedbackItemsSection] = [
        FeedbackItemsSection(items: [TopicItem(), BodyItem()]),
        FeedbackItemsSection(title: CTLocalizedString("CTFeedback.AdditionalInfo"),
                             items: [AttachmentItem()]),
    ]

    public init(topics: [TopicProtocol] = TopicItem.defaultTopics) {
        self.topics = topics
    }
}

extension FeedbackItemsDataSource: TopicsRepositoryProtocol {
    public var topics: [TopicProtocol] {
        get { return item(of: TopicItem.self)?.topics ?? [] }
        set {
            guard var item = item(of: TopicItem.self) else { return }
            item.topics = newValue
            set(item: item)
        }
    }
}

extension FeedbackItemsDataSource {
    private subscript(indexPath: IndexPath) -> Any {
        get { return sections[indexPath.section][indexPath.item] }
        set { sections[indexPath.section][indexPath.item] = newValue }
    }

    private func item<Item>(of type: Item.Type) -> Item? {
        guard let indexPath = indexPath(of: type) else { return .none }
        return self[indexPath] as? Item
    }

    private func set<Item>(item: Item) {
        guard let indexPath = indexPath(of: Item.self) else { return }
        self[indexPath] = item
    }
}

extension FeedbackItemsDataSource: FeedbackEditingItemsRepositoryProtocol {
    public var selectedTopic:   TopicProtocol? {
        get { return item(of: TopicItem.self)?.selected }
        set {
            guard var item = item(of: TopicItem.self) else { return }
            item.selected = newValue
            set(item: item)
        }
    }
    public var bodyText:        String? {
        get { return item(of: BodyItem.self)?.bodyText }
        set {
            guard var item = item(of: BodyItem.self) else { return }
            item.bodyText = newValue
            set(item: item)
        }
    }
    public var attachmentMedia: Media? {
        get { return item(of: AttachmentItem.self)?.media }
        set {
            guard var item = item(of: AttachmentItem.self) else { return }
            item.media = newValue
            set(item: item)
        }
    }

    public func indexPath<Item>(of type: Item.Type) -> IndexPath? {
        for section in sections {
            guard let index = sections.index(where: { $0 === section }),
                  let subIndex = section.items.index(where: { $0 is Item })
                else { continue }
            return IndexPath(item: subIndex, section: index)
        }
        return .none
    }
}

class FeedbackItemsSection {
    let title: String?
    var items: [Any]

    init(title: String? = .none, items: [Any]) {
        self.title = title
        self.items = items
    }
}

extension FeedbackItemsSection: Collection {
    var startIndex: Int { return items.startIndex }
    var endIndex:   Int { return items.endIndex }

    subscript(position: Int) -> Any {
        get { return items[position] }
        set { items[position] = newValue }
    }

    func index(after i: Int) -> Int { return items.index(after: i) }
}
