//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

public class FeedbackItemsDataSource {
    var sections: [FeedbackItemsSection] = []

    var numberOfSections: Int {
        return filteredSections.count
    }

    public init(topics: [TopicProtocol],
                hidesUserEmailCell: Bool = true,
                hidesAttachmentCell: Bool = false,
                hidesAppInfoSection: Bool = false) {
        sections.append(FeedbackItemsSection(title: CTLocalizedString("CTFeedback.UserDetail"),
                                             items: [UserEmailItem(isHidden: hidesUserEmailCell)]))
        sections.append(FeedbackItemsSection(items: [TopicItem(topics), BodyItem()]))
        sections.append(FeedbackItemsSection(title: CTLocalizedString("CTFeedback.AdditionalInfo"),
                                             items: [AttachmentItem(isHidden: hidesAttachmentCell)]))
        sections.append(FeedbackItemsSection(title: CTLocalizedString("CTFeedback.DeviceInfo"),
                                             items: [DeviceNameItem(),
                                                     SystemVersionItem()]))
        sections.append(FeedbackItemsSection(title: CTLocalizedString("CTFeedback.AppInfo"),
                                             items: [AppNameItem(isHidden: hidesAppInfoSection),
                                                     AppVersionItem(isHidden: hidesAppInfoSection),
                                                     AppBuildItem(isHidden: hidesAppInfoSection)]))
    }

    func section(at section: Int) -> FeedbackItemsSection {
        return filteredSections[section]
    }
}

extension FeedbackItemsDataSource {
    private var filteredSections: [FeedbackItemsSection] {
        return sections.filter { section in
            section.items.filter { !$0.isHidden }.isEmpty == false
        }
    }

    private subscript(indexPath: IndexPath) -> FeedbackItemProtocol {
        get { return filteredSections[indexPath.section][indexPath.item] }
        set { filteredSections[indexPath.section][indexPath.item] = newValue }
    }

    private func indexPath<Item>(of type: Item.Type) -> IndexPath? {
        let filtered = filteredSections
        for section in filtered {
            guard let index = filtered.firstIndex(where: { $0 === section }),
                let subIndex = section.items.firstIndex(where: { $0 is Item })
                else { continue }
            return IndexPath(item: subIndex, section: index)
        }
        return .none
    }
}

extension FeedbackItemsDataSource: FeedbackEditingItemsRepositoryProtocol {
    public func item<Item>(of type: Item.Type) -> Item? {
        guard let indexPath = indexPath(of: type) else { return .none }
        return self[indexPath] as? Item
    }

    @discardableResult
    public func set<Item:FeedbackItemProtocol>(item: Item) -> IndexPath? {
        guard let indexPath = indexPath(of: Item.self) else { return .none }
        self[indexPath] = item
        return indexPath
    }
}

class FeedbackItemsSection {
    let title: String?
    var items: [FeedbackItemProtocol]

    init(title: String? = .none, items: [FeedbackItemProtocol]) {
        self.title = title
        self.items = items
    }
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
