import XCTest
@testable import CTFeedback

class AppNameCellTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigure() {
        let cell = AppNameCell(style: .value1, reuseIdentifier: AppNameCell.reuseIdentifier)
        let item = AppNameItem(isHidden: false)
        AppNameCell.configure(cell,
                              with: item,
                              for: IndexPath(row: 0, section: 0),
                              eventHandler: .none)
        XCTAssertEqual(cell.textLabel?.text, "Name")
    }
}
