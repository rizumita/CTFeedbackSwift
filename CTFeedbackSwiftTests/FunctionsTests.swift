import XCTest
import MobileCoreServices
@testable import CTFeedback

class FunctionsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetURLFromImagePickerInfo() {
        let url                            = URL(string: "https://example.com")
        let validImageInfo: [String : Any] = [UIImagePickerControllerMediaType : kUTTypeImage,
                                              UIImagePickerControllerImageURL : url]
        XCTAssertEqual(getURLFromImagePickerInfo(validInfo), url)

        let validMovieInfo: [String : Any] = [UIImagePickerControllerMediaType : kUTTypeMovie,
                                              UIImagePickerControllerMediaURL : url]
        XCTAssertEqual(getURLFromImagePickerInfo(validMovieInfo), url)

        let invalidImageInfo: [String : Any] = [UIImagePickerControllerMediaType : kUTTypeImage,
                                                UIImagePickerControllerMediaURL : url]
        XCTAssertNil(getURLFromImagePickerInfo(invalidImageInfo))

        let invalidMovieInfo: [String : Any] = [UIImagePickerControllerMediaType : kUTTypeMovie,
                                                UIImagePickerControllerImageURL : url]
        XCTAssertNil(getURLFromImagePickerInfo(invalidMovieInfo))

        let invalidInfo: [String : Any] = ["invalid" : url]
        XCTAssertNil(getURLFromImagePickerInfo(invalidInfo))
    }
}
