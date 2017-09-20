//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import Foundation

public class FeedbackConfiguration: TopicsRepositoryProtocol {
    public static var defaultTopics:        [TopicProtocol] {
        return [Topic.question,
                Topic.request,
                Topic.bugReport,
                Topic.other]
    }
    public static var defaultCellFactories: [AnyCellFactory] {
        return [AnyCellFactory(TopicCell.self),
                AnyCellFactory(BodyCell.self)]
    }

    public let topics:     [TopicProtocol]
    public var dataSource: FeedbackItemsDataSource
    let cellFactories: [AnyCellFactory]

    public init(topics: [TopicProtocol] = FeedbackConfiguration.defaultTopics,
                dataSource: FeedbackItemsDataSource = FeedbackItemsDataSource(),
                cellFactories: [AnyCellFactory] = FeedbackConfiguration.defaultCellFactories) {
        self.topics = topics
        self.dataSource = dataSource
        self.cellFactories = cellFactories
    }
}
