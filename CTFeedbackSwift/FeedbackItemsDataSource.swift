//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

class FeedbackItemsDataSource {
    var sections: [FeedbackItemsSection] = [FeedbackItemsSection(items: [TopicItem()])]

    func updateTopicItem(with topics: [TopicProtocol]) {
        guard let indexPath = indexPath(of: TopicItem.self), var item = topicItem else { return }
        item.topics = topics
        self[indexPath] = item
    }
}

extension FeedbackItemsDataSource {
    private subscript(indexPath: IndexPath) -> FeedbackItemProtocol {
        get { return sections[indexPath.section][indexPath.item] }
        set { sections[indexPath.section][indexPath.item] = newValue }
    }

    private var topicItem: TopicItem? {
        get {
            guard let indexPath = indexPath(of: TopicItem.self) else { return .none }
            return self[indexPath] as? TopicItem
        }
        set {
            guard let indexPath = indexPath(of: TopicItem.self), let item = newValue else { return }
            self[indexPath] = item
        }
    }

    private func indexPath<Item:FeedbackItemProtocol>(of type: Item.Type) -> IndexPath? {
        for section in sections {
            guard let index = sections.index(where: { $0 === section }),
                  let subIndex = section.items.index(where: { $0 is Item })
                else { continue }
            return IndexPath(item: subIndex, section: index)
        }
        return .none
    }
}

extension FeedbackItemsDataSource: FeedbackEditingItemsRepositoryProtocol {
    var selectedTopic: TopicProtocol? {
        get { return topicItem?.selected }
        set {
            guard let indexPath = indexPath(of: TopicItem.self),
                  var item = topicItem else { return }
            item.selected = newValue
            self[indexPath] = item
        }
    }
}

class FeedbackItemsSection {
    var items: [FeedbackItemProtocol]

    init(items: [FeedbackItemProtocol]) { self.items = items }
}

extension FeedbackItemsSection: Collection {
    var startIndex: Int { return items.startIndex }
    var endIndex:   Int { return items.endIndex }

    subscript(position: Int) -> FeedbackItemProtocol {
        get { return items[position] }
        set { items[position] = newValue }
    }

    func index(after i: Int) -> Int { return items.index(after: i) }
}
