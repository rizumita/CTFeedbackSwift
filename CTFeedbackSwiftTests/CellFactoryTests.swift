import XCTest
@testable import CTFeedbackSwift

class CellFactoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReuseIdentifier() {
        XCTAssertEqual(TestCellFactory.reuseIdentifier, "TestCellFactory")
    }
}

class AnyCellFactoryTests: XCTestCase {
    func testSuitable() {
        let concreteFactory = TestCellFactory.self
        let factory         = AnyCellFactory(concreteFactory)
        XCTAssertTrue(factory.suitable(for: ""))
    }

    func testConfigure() {
        let concreteFactory = TestCellFactory.self
        let factory         = AnyCellFactory(concreteFactory)
        let cell            = UITableViewCell()
        let indexPath       = IndexPath(row: 0, section: 0)
        _ = factory.configure(cell,
                              with: "test",
                              for: indexPath,
                              eventHandler: "Handler")
        XCTAssertTrue(concreteFactory.cell === cell)
        XCTAssertEqual(concreteFactory.item, "test")
        XCTAssertEqual(concreteFactory.indexPath, indexPath)
        XCTAssertEqual(concreteFactory.eventHandler, "Handler")
    }
}

class UITableView_ExtensionsTests: XCTestCase {
    func testDequeueCell() {
        let concreteFactory = TestCellFactory.self
        let factory         = AnyCellFactory(concreteFactory)
        let tableView       = UITableView()
        tableView.register(with: factory)
        let indexPath             = IndexPath(row: 0, section: 0)
        let cell: UITableViewCell = tableView.dequeueCell(to: "Item",
                                                          from: [factory],
                                                          for: indexPath,
                                                          eventHandler: "EventHandler")
        XCTAssertTrue(concreteFactory.cell === cell)
        XCTAssertEqual(concreteFactory.item, "Item")
        XCTAssertEqual(concreteFactory.indexPath, indexPath)
        XCTAssertEqual(concreteFactory.eventHandler, "EventHandler")
    }
}

class TestCellFactory: CellFactoryProtocol {
    static var cell:         UITableViewCell?
    static var item:         String?
    static var indexPath:    IndexPath?
    static var eventHandler: String?

    static func configure(_ cell: UITableViewCell,
                          with item: String,
                          for indexPath: IndexPath,
                          eventHandler: String?) {
        self.cell = cell
        self.item = item
        self.indexPath = indexPath
        self.eventHandler = eventHandler
    }
}
