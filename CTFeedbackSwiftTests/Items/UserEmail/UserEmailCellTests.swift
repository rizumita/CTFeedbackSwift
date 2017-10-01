import XCTest
@testable import CTFeedback

class UserEmailCellTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHandleTextDidChange() {
        let cell      = UserEmailCell(style: .default,
                                      reuseIdentifier: UserEmailCell.reuseIdentifier)
        let item      = UserEmailItem(isHidden: false)
        let indexPath = IndexPath(row: 0, section: 0)
        let handler   = MockUserEmailCellEventHandler()
        UserEmailCell.configure(cell, with: item, for: indexPath, eventHandler: handler)
        cell.textField.text = "test"
        _ = cell.textField(cell.textField,
                           shouldChangeCharactersIn: NSRange(location: 0, length: 4),
                           replacementString: "")
        XCTAssertEqual(handler.invokedUserEmailTextDidChangeParameters?.text, "test")
    }
}

class MockUserEmailCellEventHandler: UserEmailCellEventProtocol {
    var invokedUserEmailTextDidChange               = false
    var invokedUserEmailTextDidChangeCount          = 0
    var invokedUserEmailTextDidChangeParameters: (text: String?, Void)?
    var invokedUserEmailTextDidChangeParametersList = [(text: String?, Void)]()

    func userEmailTextDidChange(_ text: String?) {
        invokedUserEmailTextDidChange = true
        invokedUserEmailTextDidChangeCount += 1
        invokedUserEmailTextDidChangeParameters = (text, ())
        invokedUserEmailTextDidChangeParametersList.append((text, ()))
    }
}
