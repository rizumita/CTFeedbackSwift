//
//  FeedbackEditingServiceTests.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/17.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import XCTest
@testable import CTFeedback

class FeedbackEditingServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSelectTopic() {
        let topicsRepository = MockTopicsRepository()
        topicsRepository.stubbedTopics = FeedbackConfiguration.defaultTopics
        let itemsRepository     = MockFeedbackEditingItemsRepository()
        let editingEventHandler = MockFeedbackEditingEventHandler()
        let service             = FeedbackEditingService(topicsRepository: topicsRepository,
                                                         editingItemsRepository: itemsRepository,
                                                         feedbackEditingEventHandler: editingEventHandler)
        let topicsSelector      = MockTopicsSelector()
        service.selectTopic(selector: topicsSelector)
        XCTAssertTrue(editingEventHandler.invokedSelectedTopicUpdated)
        XCTAssertEqual(topicsRepository.stubbedTopics.last!.title,
                       itemsRepository.selectedTopic!.title)
    }

}

class MockTopicsRepository: TopicsRepositoryProtocol {
    var invokedTopicsGetter             = false
    var invokedTopicsGetterCount        = 0
    var stubbedTopics: [TopicProtocol]! = []
    var topics:        [TopicProtocol] {
        invokedTopicsGetter = true
        invokedTopicsGetterCount += 1
        return stubbedTopics
    }
}

class MockFeedbackEditingItemsRepository: FeedbackEditingItemsRepositoryProtocol {
    var invokedSelectedTopicSetter      = false
    var invokedSelectedTopicSetterCount = 0
    var invokedSelectedTopic: TopicProtocol?
    var invokedSelectedTopicList        = [TopicProtocol?]()
    var invokedSelectedTopicGetter      = false
    var invokedSelectedTopicGetterCount = 0
    var stubbedSelectedTopic: TopicProtocol!
    var selectedTopic:        TopicProtocol? {
        set {
            invokedSelectedTopicSetter = true
            invokedSelectedTopicSetterCount += 1
            invokedSelectedTopic = newValue
            invokedSelectedTopicList.append(newValue)
        }
        get {
            invokedSelectedTopicGetter = true
            invokedSelectedTopicGetterCount += 1
            return stubbedSelectedTopic ?? invokedSelectedTopic
        }
    }
}

class MockFeedbackEditingEventHandler: FeedbackEditingEventProtocol {
    var invokedSelectedTopicUpdated      = false
    var invokedSelectedTopicUpdatedCount = 0

    func selectedTopicUpdated() {
        invokedSelectedTopicUpdated = true
        invokedSelectedTopicUpdatedCount += 1
    }
}

class MockTopicsSelector: TopicsSelectorProtocol {
    var invokedSelectTopics               = false
    var invokedSelectTopicsCount          = 0
    var invokedSelectTopicsParameters: (topics: [TopicProtocol], eventHandler: TopicsEventProtocol)?
    var invokedSelectTopicsParametersList = [(topics: [TopicProtocol],
                                              eventHandler: TopicsEventProtocol)]()

    func selectTopics(topics: [TopicProtocol], eventHandler: TopicsEventProtocol) {
        invokedSelectTopics = true
        invokedSelectTopicsCount += 1
        invokedSelectTopicsParameters = (topics, eventHandler)
        invokedSelectTopicsParametersList.append((topics, eventHandler))
        eventHandler.topicWasSelected(topics.last!)
    }
}
