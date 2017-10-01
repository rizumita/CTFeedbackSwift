//
//  TopicsViewController.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/08.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit

class TopicsViewController: UITableViewController {
    let feedbackEditingService: FeedbackEditingServiceProtocol
    let topics: [TopicProtocol]

    init(service: FeedbackEditingServiceProtocol) {
        self.feedbackEditingService = service
        self.topics = self.feedbackEditingService.topics
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = CTLocalizedString("CTFeedback.Topics")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TopicsViewController {
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topics.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let cell       = tableView.dequeueReusableCell(withIdentifier: identifier)
                         ?? UITableViewCell(style: .default, reuseIdentifier: identifier)
        let topic      = topics[indexPath.row]
        cell.textLabel?.text = topic.localizedTitle
        return cell
    }
}

extension TopicsViewController {
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        feedbackEditingService.update(selectedTopic: topic)
        dismiss(animated: true)
    }
}
