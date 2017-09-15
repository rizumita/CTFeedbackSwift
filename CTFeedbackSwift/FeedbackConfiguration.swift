//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public class FeedbackConfiguration: TopicsRepositoryProtocol {
    public static var defaultTopics: [TopicProtocol] {
        return [Topic.question,
                Topic.request,
                Topic.bugReport,
                Topic.other]
    }
    public var topics: [TopicProtocol]

    public init(topics: [TopicProtocol] = FeedbackConfiguration.defaultTopics) {
        self.topics = topics
    }
}
