import XCTest
@testable import CTFeedbackSwift

class TopicItemTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSelected() {
        var item = TopicItem([])
        let topics = TopicItem.defaultTopics

        XCTAssertNil(item.selected)

        item.topics = topics
        XCTAssertEqual(item.selected?.title, topics.first?.title)

        item.selected = topics[1]
        XCTAssertEqual(item.selected?.title, topics[1].title)
    }
}
