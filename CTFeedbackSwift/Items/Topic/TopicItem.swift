//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public struct TopicItem: FeedbackItemProtocol {
    public static var defaultTopics: [TopicProtocol] {
        return [Topic.question,
                Topic.request,
                Topic.bugReport,
                Topic.other]
    }

    var topicTitle: String { return selected?.localizedTitle ?? topics.first?.localizedTitle ?? "" }
    var topics:     [TopicProtocol] = []
    var selected:   TopicProtocol? {
        get { return _selected ?? topics.first }
        set { _selected = newValue }
    }
    private var _selected: TopicProtocol?
    public let isHidden: Bool

    init(_ topics: [TopicProtocol]) {
        self.topics = topics
        self.isHidden = topics.isEmpty
    }
}
