//
//  FeedbackViewController.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/07.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit
import Dispatch
import MobileCoreServices

public class FeedbackViewController: UITableViewController {
    public var  configuration: FeedbackConfiguration {
        didSet { updateDataSource(configuration: configuration) }
    }
    private let cellFactories = [AnyCellFactory(TopicCell.self),
                                 AnyCellFactory(BodyCell.self),
                                 AnyCellFactory(AttachmentCell.self),
                                 AnyCellFactory(DeviceNameCell.self),
                                 AnyCellFactory(SystemVersionCell.self),
                                 AnyCellFactory(AppNameCell.self),
                                 AnyCellFactory(AppVersionCell.self),
                                 AnyCellFactory(AppBuildCell.self)]

    private lazy var feedbackEditingService: FeedbackEditingServiceProtocol = {
        return FeedbackEditingService(topicsRepository: configuration.dataSource,
                                      editingItemsRepository: configuration.dataSource,
                                      feedbackEditingEventHandler: self)
    }()

    public init(configuration: FeedbackConfiguration) {
        self.configuration = configuration

        super.init(style: .grouped)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0

        cellFactories.forEach(tableView.register(with:))
        updateDataSource(configuration: configuration)

        title = CTLocalizedString("CTFeedback.FeedbackViewTitle")
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedbackViewController {
    // MARK: - UITableViewDataSource

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return configuration.dataSource.sections.count
    }

    override public func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int {
        return configuration.dataSource.sections[section].count
    }

    override public func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = configuration.dataSource.sections[indexPath.section][indexPath.row]
        return tableView.dequeueCell(to: item,
                                     from: cellFactories,
                                     for: indexPath,
                                     eventHandler: self)
    }

    override public func tableView(_ tableView: UITableView,
                                   titleForHeaderInSection section: Int) -> String? {
        return configuration.dataSource.sections[section].title
    }
}

extension FeedbackViewController {
    // UITableViewDelegate

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = configuration.dataSource.sections[indexPath.section][indexPath.row]
        switch item {
        case _ as TopicItem:
            showTopicsView()
        case _ as AttachmentItem:
            showAttachmentViewOrAlert()
        default: ()
        }
    }
}

extension FeedbackViewController: FeedbackEditingEventProtocol {
    public func updated(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
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

extension FeedbackViewController: AttachmentCellEventProtocol {
    func showImage(of item: AttachmentItem) {}
}

extension FeedbackViewController {
    private func updateDataSource(configuration: FeedbackConfiguration) {
        tableView.reloadData()
    }

    private func showTopicsView() {
        let controller = TopicsViewController(service: feedbackEditingService)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self

        DispatchQueue.main.async {
            self.present(controller, animated: true)
        }
    }

    private func showAttachmentViewOrAlert() {
        if feedbackEditingService.hasAttachedMedia {
            showAttachmentActionSheet()
        } else {
            showImagePicker()
        }
    }

    private func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }

    private func showAttachmentActionSheet() {
        let alertController = UIAlertController(title: .none,
                                                message: .none,
                                                preferredStyle: .actionSheet)
        let actions = [
            UIAlertAction(title: CTLocalizedString("CTFeedback.Delete"), style: .destructive) { _ in
                self.feedbackEditingService.update(attachmentMedia: .none)
            },
            UIAlertAction(title: CTLocalizedString("CTFeedback.Replace"),
                          style: .default) { _ in self.showImagePicker() },
            UIAlertAction(title: CTLocalizedString("CTFeedback.Cancel"), style: .cancel)
        ]
        actions.forEach(alertController.addAction)
        present(alertController, animated: true)
    }
}

extension FeedbackViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String : Any]) {
        switch getMediaFromImagePickerInfo(info) {
        case let media?:
            feedbackEditingService.update(attachmentMedia: media)
            dismiss(animated: true)
        case _:
            dismiss(animated: true)
            let title           = CTLocalizedString("CTFeedback.UnknownError")
            let alertController = UIAlertController(title: title,
                                                    message: .none,
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.OK"),
                                                    style: .default))
            present(alertController, animated: true)
        }

    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
