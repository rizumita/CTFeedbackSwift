import XCTest
@testable import CTFeedbackSwift

class DeviceNameCellTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConfigure() {
        let cell      = DeviceNameCell(style: .default,
                                       reuseIdentifier: DeviceNameCell.reuseIdentifier)
        let item      = DeviceNameItem()
        let indexPath = IndexPath(row: 0, section: 0)
        DeviceNameCell.configure(cell, with: item, for: indexPath, eventHandler: .none)
        XCTAssertEqual(cell.textLabel?.text, "Device")
        
        switch cell.detailTextLabel?.text {
        case "Simulator", "arm64", "x86_64":
            break
        default:
            XCTFail(cell.detailTextLabel?.text ?? "")
        }
    }
}
