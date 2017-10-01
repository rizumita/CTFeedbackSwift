import XCTest
@testable import CTFeedback

class TopicCellTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigure() {
        let cell = TopicCell(style: .default, reuseIdentifier: TopicCell.reuseIdentifier)
        let item = TopicItem(TopicItem.defaultTopics)
        let indexPath = IndexPath(row: 0, section: 0)
        TopicCell.configure(cell, with: item, for: indexPath, eventHandler: .none)
        XCTAssertEqual(cell.textLabel?.text, "Topic")
        XCTAssertEqual(cell.detailTextLabel?.text, item.selected?.localizedTitle)
    }
}
