//
// Created by 和泉田 領一 on 2017/09/07.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

class TopicCellFactory: CellFactoryProtocol {
    func cell(with item: TopicItem,
              tableView: UITableView,
              at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.reuseIdentifier,
                                                       for: indexPath) as? TopicCell
            else { fatalError() }

        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.topicTitle;
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
}
