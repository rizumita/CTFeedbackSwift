import XCTest
@testable import CTFeedback

class FeedbackItemsDataSourceTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNumberOfSections() {
        let dataSource = FeedbackItemsDataSource(topics: TopicItem.defaultTopics,
                                                 hidesUserEmailCell: true,
                                                 hidesAttachmentCell: false,
                                                 hidesAppInfoSection: true)
        XCTAssertEqual(dataSource.numberOfSections, 4)
    }

    func testSection() {
        let dataSource = FeedbackItemsDataSource(topics: TopicItem.defaultTopics,
                                                 hidesUserEmailCell: true,
                                                 hidesAttachmentCell: false,
                                                 hidesAppInfoSection: true)
        XCTAssertEqual(dataSource.section(at: 0).title, "User Detail")
    }

    func testItem() {
        let dataSource       = FeedbackItemsDataSource(topics: TopicItem.defaultTopics,
                                                       hidesUserEmailCell: true,
                                                       hidesAttachmentCell: false,
                                                       hidesAppInfoSection: true)
        let item: TopicItem? = dataSource.item(of: TopicItem.self)
        XCTAssertNotNil(item)
    }

    func testSetItem() {
        let dataSource = FeedbackItemsDataSource(topics: TopicItem.defaultTopics,
                                                 hidesUserEmailCell: true,
                                                 hidesAttachmentCell: false,
                                                 hidesAppInfoSection: true)
        guard var item = dataSource.item(of: BodyItem.self) else {
            XCTFail()
            return
        }

        item.bodyText = "body"
        let indexPath: IndexPath? = dataSource.set(item: item)
        XCTAssertNotNil(indexPath)
    }
}
