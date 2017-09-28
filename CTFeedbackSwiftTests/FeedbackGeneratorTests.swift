import XCTest
@testable import CTFeedback

class FeedbackGeneratorTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGenerateNoHTML() {
        let configuration = FeedbackConfiguration(subject: "Subject",
                                                  additionalDiagnosticContent: "Additional",
                                                  topics: TopicItem.defaultTopics,
                                                  toRecipients: ["to@example.com"],
                                                  ccRecipients: ["cc@example.com"],
                                                  bccRecipients: ["bcc@example.com"],
                                                  usesHTML: false)
        do {
            let feedback = try FeedbackGenerator.generate(configuration: configuration,
                                                          repository: configuration.dataSource)
            XCTAssertEqual(feedback.subject, "Subject")
            XCTAssertTrue(feedback.body.contains("Additional"))
            XCTAssertFalse(feedback.isHTML)
            XCTAssertEqual(feedback.to, ["to@example.com"])
            XCTAssertEqual(feedback.cc, ["cc@example.com"])
            XCTAssertEqual(feedback.bcc, ["bcc@example.com"])
        } catch {
            XCTFail()
        }
    }

    func testGenerateHTML() {
        let configuration = FeedbackConfiguration(subject: "Subject",
                                                  additionalDiagnosticContent: "Additional",
                                                  topics: TopicItem.defaultTopics,
                                                  toRecipients: ["to@example.com"],
                                                  ccRecipients: ["cc@example.com"],
                                                  bccRecipients: ["bcc@example.com"],
                                                  usesHTML: false)
        do {
            let feedback = try FeedbackGenerator.generate(configuration: configuration,
                                                          repository: configuration.dataSource)
            XCTAssertEqual(feedback.subject, "Subject")
            XCTAssertTrue(feedback.body.contains("Additional"))
            XCTAssertTrue(feedback.isHTML)
            XCTAssertEqual(feedback.to, ["to@example.com"])
            XCTAssertEqual(feedback.cc, ["cc@example.com"])
            XCTAssertEqual(feedback.bcc, ["bcc@example.com"])
        } catch {
            XCTFail()
        }
    }
}
