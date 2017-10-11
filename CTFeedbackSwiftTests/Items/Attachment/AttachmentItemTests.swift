import XCTest
@testable import CTFeedbackSwift

class AttachmentItemTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAttached() {
        var item = AttachmentItem(isHidden: false)
        XCTAssertFalse(item.attached)

        item.media = .image(UIImage(color: .red)!)
        XCTAssertTrue(item.attached)

        item.media = .video(UIImage(color: .red)!, URL(string: "https://example.com")!)
        XCTAssertTrue(item.attached)
    }
    
    func testImage() {
        var item = AttachmentItem(isHidden: false)
        XCTAssertNil(item.image)

        let image = UIImage(color: .red)!
        item.media = .image(image)
        XCTAssertNotNil(item.image)
        XCTAssertTrue(item.image === image)

        item.media = .video(image, URL(string: "https://example.com")!)
        XCTAssertNotNil(item.image)
        XCTAssertTrue(item.image === image)
    }
}
