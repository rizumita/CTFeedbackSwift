//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public class FeedbackConfiguration {
    public var dataSource: FeedbackItemsDataSource
    public var usesHTML:   Bool

    /*
    If topics array contains no topics, topics cell is hidden.
    */
    public init(topics: [TopicProtocol] = TopicItem.defaultTopics,
                toRecipients: [String],
                ccRecipients: [String] = [],
                bccRecipients: [String] = [],
                hidesUserEmailCell: Bool = true,
                hidesAttachmentCell: Bool = false,
                hidesAppInfoSection: Bool = false,
                usesHTML: Bool = false) {
        self.dataSource = FeedbackItemsDataSource(topics: topics,
                                                  hidesUserEmailCell: hidesUserEmailCell,
                                                  hidesAttachmentCell: hidesAttachmentCell,
                                                  hidesAppInfoSection: hidesAppInfoSection)
        self.usesHTML = usesHTML
    }
}
