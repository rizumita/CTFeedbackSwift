//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

protocol CellFactoryProtocol {
    associatedtype Item: FeedbackItemProtocol

    func cell(with item: Item,
              tableView: UITableView,
              at indexPath: IndexPath) -> UITableViewCell
}

class CellFactorySet {
    let factories = [
        AnyCellFactory(TopicCellFactory()),
        AnyCellFactory(BodyCellFactory())
    ]

    func cell(with item: FeedbackItemProtocol,
              tableView: UITableView,
              at indexPath: IndexPath) -> UITableViewCell {
        for factory in factories {
            if let cell = factory.cell(with: item, tableView: tableView, at: indexPath) {
                return cell
            }
        }
        fatalError()
    }
}

class AnyCellFactory {
    private let cellFunction: (FeedbackItemProtocol, UITableView, IndexPath) -> UITableViewCell?

    init<Factory:CellFactoryProtocol>(_ cellFactory: Factory) {
        cellFunction = { item, tableView, indexPath in
            guard let _item = item as? Factory.Item else { return .none }
            return cellFactory.cell(with: _item, tableView: tableView, at: indexPath)
        }
    }

    func cell(with item: FeedbackItemProtocol,
              tableView: UITableView,
              at indexPath: IndexPath) -> UITableViewCell? {
        return cellFunction(item, tableView, indexPath)
    }
}

class BodyCellFactory: CellFactoryProtocol {
    func cell(with item: BodyItem,
              tableView: UITableView,
              at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.reuseIdentifier,
                                                       for: indexPath) as? TopicCell
            else { fatalError() }

        return cell
    }
}