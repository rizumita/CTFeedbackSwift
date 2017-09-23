//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

protocol CellFactoryProtocol {
    associatedtype Item
    associatedtype Cell: UITableViewCell
    associatedtype EventHandler

    static var reuseIdentifier: String { get }

    static func configure(_ cell: Cell,
                          with item: Item,
                          for indexPath: IndexPath,
                          eventHandler: EventHandler)
}

extension CellFactoryProtocol {
    static var reuseIdentifier: String { return String(describing: self) }

    static func suitable(for item: Any) -> Bool { return item is Item }

    static func configure(_ cell: UITableViewCell,
                          with item: Any,
                          for indexPath: IndexPath,
                          eventHandler: Any?) -> UITableViewCell? {
        guard let cell = cell as? Cell,
              let item = item as? Item,
              let eventHandler = eventHandler as? EventHandler
            else { return .none }
        configure(cell, with: item, for: indexPath, eventHandler: eventHandler)
        return cell
    }
}

public class AnyCellFactory {
    let cellType:        AnyClass
    let reuseIdentifier: String
    private let suitableClosure:      (Any) -> Bool
    private let configureCellClosure: (UITableViewCell, Any, IndexPath, Any?) -> UITableViewCell?

    init<Factory:CellFactoryProtocol>(_ cellFactory: Factory.Type) {
        cellType = Factory.Cell.self
        reuseIdentifier = cellFactory.reuseIdentifier
        suitableClosure = cellFactory.suitable(for:)
        configureCellClosure = cellFactory.configure(_:with:for:eventHandler:)
    }

    func suitable(for item: Any) -> Bool { return suitableClosure(item) }

    func configure(_ cell: UITableViewCell,
                   with item: Any,
                   for indexPath: IndexPath,
                   eventHandler: Any?) -> UITableViewCell? {
        return configureCellClosure(cell, item, indexPath, eventHandler)
    }

    static func cellFactoryFilter() -> (Any, [AnyCellFactory]) -> AnyCellFactory? {
        var cache = [String : AnyCellFactory]()
        return { item, factories in
            let itemType = String(describing: type(of: item))
            if let factory = cache[itemType] {
                return factory
            } else if let factory = _cellFactoryFilter(item, factories) {
                cache[itemType] = factory
                return factory
            } else {
                return .none
            }
        }
    }
}

extension UITableView {
    func register(with cellFactory: AnyCellFactory) {
        register(cellFactory.cellType, forCellReuseIdentifier: cellFactory.reuseIdentifier)
    }

    func dequeueCell(to item: Any,
                     from cellFactories: [AnyCellFactory],
                     for indexPath: IndexPath,
                     filter: (Any, [AnyCellFactory]) -> AnyCellFactory? = _cellFactoryFilter,
                     eventHandler: Any?) -> UITableViewCell {
        guard let cellFactory = filter(item, cellFactories) else { fatalError() }
        let cell = dequeueReusableCell(withIdentifier: cellFactory.reuseIdentifier, for: indexPath)
        guard let configured = cellFactory.configure(cell,
                                                     with: item,
                                                     for: indexPath,
                                                     eventHandler: eventHandler)
            else { fatalError() }
        return configured
    }
}

let _cellFactoryFilter: (Any, [AnyCellFactory]) -> AnyCellFactory? = { item, factories in
    return factories.first { $0.suitable(for: item) }
}
