//
//  FeedbackViewController.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/07.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit

public class FeedbackViewController: UITableViewController {
    public var configuration: FeedbackConfiguration {
        didSet { updateDataSource(configuration: configuration) }
    }

    private var feedbackEditingService: FeedbackEditingServiceProtocol

    private func updateDataSource(configuration: FeedbackConfiguration) {
        dataSource.updateTopicItem(with: configuration.topics)
        tableView.reloadData()
    }

    private var dataSource  = FeedbackItemsDataSource()
    private let cellFactory = CellFactorySet()

    public init(configuration: FeedbackConfiguration) {
        self.configuration = configuration
        self.feedbackEditingService = FeedbackEditingService(topicsRepository: configuration,
                                                             editingItemsRepository: dataSource)
        super.init(style: .grouped)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        updateDataSource(configuration: configuration)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedbackViewController {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.sections.count
    }

    public override func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int {
        return dataSource.sections[section].count
    }

    public override func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource.sections[indexPath.section][indexPath.row]
        return cellFactory.cell(with: item, tableView: tableView, at: indexPath)
    }
}

extension FeedbackViewController {
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.sections[indexPath.section][indexPath.row]
        if item is TopicItem {
            feedbackEditingService.selectTopic(selector: self)
        }
    }
}

extension FeedbackViewController {
    private func registerCells() {
        tableView.register(TopicCell.self, forCellReuseIdentifier: TopicCell.reuseIdentifier)
    }
}
