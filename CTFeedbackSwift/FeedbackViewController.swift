//
//  FeedbackViewController.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/07.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit
import Dispatch

public class FeedbackViewController: UITableViewController {
    public var configuration: FeedbackConfiguration {
        didSet { updateDataSource(configuration: configuration) }
    }

    private var feedbackEditingService: FeedbackEditingServiceProtocol

    private func updateDataSource(configuration: FeedbackConfiguration) {
        configuration.dataSource.updateTopicItem(with: configuration.topics)
        tableView.reloadData()
    }

    public init(configuration: FeedbackConfiguration) {
        self.configuration = configuration
        let handler = FeedbackEditingEventHandler()
        self.feedbackEditingService = FeedbackEditingService(topicsRepository: configuration,
                                                             editingItemsRepository: configuration.dataSource,
                                                             feedbackEditingEventHandler: handler)
        super.init(style: .grouped)
        handler.controller = self
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

        configuration.cellFactories.forEach(tableView.register(with:))
        updateDataSource(configuration: configuration)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedbackViewController {
    // MARK: - UITableViewDataSource

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return configuration.dataSource.sections.count
    }

    public override func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int {
        return configuration.dataSource.sections[section].count
    }

    public override func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = configuration.dataSource.sections[indexPath.section][indexPath.row]
        return tableView.dequeueCell(to: item,
                                     from: configuration.cellFactories,
                                     for: indexPath,
                                     eventHandler: self)
    }
}

extension FeedbackViewController {
    // UITableViewDelegate

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = configuration.dataSource.sections[indexPath.section][indexPath.row]
        switch item {
        case let item as TopicItem:
            showTopicsView()
        default: ()
        }
    }
}

extension FeedbackViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        return DrawUpPresentationController(presentedViewController: presented,
                                            presenting: presenting)
    }
}

extension FeedbackViewController: BodyCellEventProtocol {
    func bodyCellHeightChanged() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func bodyTextDidChange(_ text: String?) {
        feedbackEditingService.update(bodyText: text)
    }
}

extension FeedbackViewController {
    private func showTopicsView() {
        let controller = TopicsViewController(service: feedbackEditingService)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self

        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }
}