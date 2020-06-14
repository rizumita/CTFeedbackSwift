//
//  MainViewController.swift
//  CTFeedbackDemo
//
//  Created by 和泉田 領一 on 2017/09/07.
//  Copyright © 2017年 CAPH TECH. All rights reserved.
//

import UIKit
import CTFeedbackSwift

class MainViewController: UITableViewController {
    enum PresentationType: String {
        case feedback       = "Feedback"
        case feedbackCustom = "Feedback Custom"
        case feedbackSimple = "Feedback Simple"
        case feedbackModal  = "Feedback Modal"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Main"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath),
              let identifier = cell.reuseIdentifier,
              let type = PresentationType(rawValue: identifier)
            else { fatalError() }

        switch type {
        case .feedback: showFeedback()
        case .feedbackCustom: ()
        case .feedbackSimple: ()
        case .feedbackModal: showFeedbackByModal()
        }
    }

    private func showFeedback() {
        let configuration = FeedbackConfiguration(toRecipients: ["test@example.com"],
                                                  usesHTML: true)
        let controller    = FeedbackViewController(configuration: configuration)
        navigationController?.pushViewController(controller, animated: true)
    }

    private func showFeedbackByModal() {
        let configuration = FeedbackConfiguration(toRecipients: ["test@example.com"],
                                                  usesHTML: true)
        let controller    = FeedbackViewController(configuration: configuration)
        let nav = UINavigationController(rootViewController: controller)
        navigationController?.present(nav, animated: true)
    }
}
