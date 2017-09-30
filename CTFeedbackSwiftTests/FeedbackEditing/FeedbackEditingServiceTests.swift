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
    var itemsRepository: MockFeedbackEditingItemsRepository!
    var eventHandler:    MockFeedbackEditingEventHandler!
    var service:         FeedbackEditingService!

    override func setUp() {
        super.setUp()

        ready()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    private func ready() {
        itemsRepository = MockFeedbackEditingItemsRepository()
        eventHandler = MockFeedbackEditingEventHandler()
        service = FeedbackEditingService(editingItemsRepository: itemsRepository,
                                         feedbackEditingEventHandler: eventHandler)
    }

    func testTopics() {
        itemsRepository.set(item: TopicItem(TopicItem.defaultTopics))
        let topics = service.topics
        XCTAssertEqual(topics.count, 4)
    }

    func testHasAttachedMediaWithNoMedia() {
        let item = AttachmentItem(isHidden: false)
        itemsRepository.set(item: item)
        XCTAssertFalse(service.hasAttachedMedia)
    }

    func testHasAttachedMediaWithImage() {
        var item = AttachmentItem(isHidden: false)
        item.media = .image(UIImage())
        itemsRepository.set(item: item)
        XCTAssertTrue(service.hasAttachedMedia)
    }

    func testUpdateUserEmailText() {
        itemsRepository.set(item: UserEmailItem(isHidden: false))
        XCTAssertNil(itemsRepository.item(of: UserEmailItem.self)?.email)
        service.update(userEmailText: "test")
        XCTAssertEqual(itemsRepository.item(of: UserEmailItem.self)?.email, "test")
    }

    func testUpdateBodyText() {
        itemsRepository.set(item: BodyItem(bodyText: .none))
        XCTAssertNil(itemsRepository.item(of: BodyItem.self)?.bodyText)
        service.update(bodyText: "test")
        XCTAssertEqual(itemsRepository.item(of: BodyItem.self)?.bodyText, "test")
    }

    func testUpdateSelectedTopic() {
        itemsRepository.set(item: TopicItem(TopicItem.defaultTopics))
        XCTAssertNil(eventHandler.invokedUpdatedParameters)
        service.update(selectedTopic: TopicItem.defaultTopics[1])
        XCTAssertEqual(eventHandler.invokedUpdatedParameters?.indexPath,
                       IndexPath(row: 0, section: 0))
    }

    func testUpdateAttachmentMedia() {
        itemsRepository.set(item: AttachmentItem(isHidden: false))
        service.update(attachmentMedia: .image(UIImage()))
        XCTAssertEqual(eventHandler.invokedUpdatedParameters?.indexPath,
                       IndexPath(row: 0, section: 0))
    }

    func testGenerateFeedback() {
        let dataSource = FeedbackItemsDataSource(topics: TopicItem.defaultTopics)
        service = FeedbackEditingService(editingItemsRepository: dataSource,
                                         feedbackEditingEventHandler: eventHandler)
        do {
            let configuration = FeedbackConfiguration(subject: "String",
                                                      additionalDiagnosticContent: "additional",
                                                      topics: TopicItem.defaultTopics,
                                                      toRecipients: ["test@example.com"],
                                                      ccRecipients: ["cc@example.com"],
                                                      bccRecipients: ["bcc@example.com"])
            let feedback      = try service.generateFeedback(configuration: configuration)
            XCTAssertEqual(feedback.subject, "String")
            XCTAssertEqual(feedback.to, ["test@example.com"])
            XCTAssertEqual(feedback.cc, ["cc@example.com"])
            XCTAssertEqual(feedback.bcc, ["bcc@example.com"])
            XCTAssertFalse(feedback.isHTML)
        } catch {
            XCTFail()
        }
    }
}

class MockFeedbackEditingItemsRepository: FeedbackEditingItemsRepositoryProtocol {
    var stubbedItems: [Any] = []

    func item<Item>(of type: Item.Type) -> Item? {
        return stubbedItems.filter { item in item is Item }.first as? Item
    }

    @discardableResult
    func set<Item>(item: Item) -> IndexPath? {
        if let index = stubbedItems.index(where: { stored in stored is Item }) {
            stubbedItems.remove(at: index)
        }
        stubbedItems.append(item)
        return IndexPath(row: 0, section: 0)
    }
}

class MockFeedbackEditingEventHandler: FeedbackEditingEventProtocol {
    var invokedUpdated               = false
    var invokedUpdatedCount          = 0
    var invokedUpdatedParameters: (indexPath: IndexPath, Void)?
    var invokedUpdatedParametersList = [(indexPath: IndexPath, Void)]()

    func updated(at indexPath: IndexPath) {
        invokedUpdated = true
        invokedUpdatedCount += 1
        invokedUpdatedParameters = (indexPath, ())
        invokedUpdatedParametersList.append((indexPath, ()))
    }
}
