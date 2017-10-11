import XCTest
@testable import CTFeedbackSwift

class SystemVersionCellTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigure() {
        let cell = SystemVersionCell(style: .default,
                                     reuseIdentifier: SystemVersionCell.reuseIdentifier)
        let item = SystemVersionItem()
        let indexPath = IndexPath(row: 0, section: 0)
        SystemVersionCell.configure(cell, with: item, for: indexPath, eventHandler: .none)
        XCTAssertEqual(cell.textLabel?.text, "iOS")
        XCTAssertEqual(cell.detailTextLabel?.text, item.version)
    }
}
