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
import MessageUI

public class FeedbackViewController: UITableViewController {
    public var replacedFeedbackSendingAction: ((Feedback) -> ())?
    public var feedbackDidFailed:             ((MFMailComposeResult, NSError) -> ())?
    public var configuration:                 FeedbackConfiguration {
        didSet { updateDataSource(configuration: configuration) }
    }

    private let cellFactories = [AnyCellFactory(UserEmailCell.self),
                                 AnyCellFactory(TopicCell.self),
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

    private var popNavigationBarHiddenState: (((Bool) -> ()) -> ())?

    public init(configuration: FeedbackConfiguration) {
        self.configuration = configuration

        super.init(style: .grouped)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.keyboardDismissMode = .onDrag

        cellFactories.forEach(tableView.register(with:))
        updateDataSource(configuration: configuration)

        title = CTLocalizedString("CTFeedback.FeedbackViewTitle")
        navigationItem
            .rightBarButtonItem = UIBarButtonItem(title: CTLocalizedString("CTFeedback.Mail"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(mailButtonTapped(_:)))
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        popNavigationBarHiddenState = push(navigationController?.isNavigationBarHidden)
        navigationController?.isNavigationBarHidden = false

        configureLeftBarButtonItem()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        popNavigationBarHiddenState?({ self.navigationController?.isNavigationBarHidden = $0 })
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedbackViewController {
    // MARK: - UITableViewDataSource

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return configuration.dataSource.numberOfSections
    }

    override public func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int {
        return configuration.dataSource.section(at: section).count
    }

    override public func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = configuration.dataSource.section(at: indexPath.section)[indexPath.row]
        return tableView.dequeueCell(to: item,
                                     from: cellFactories,
                                     for: indexPath,
                                     eventHandler: self)
    }

    override public func tableView(_ tableView: UITableView,
                                   titleForHeaderInSection section: Int) -> String? {
        return configuration.dataSource.section(at: section).title
    }
}

extension FeedbackViewController {
    // MARK: - UITableViewDelegate

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = configuration.dataSource.section(at: indexPath.section)[indexPath.row]
        switch item {
        case _ as TopicItem:
            showTopicsView()
        case _ as AttachmentItem:
            showAttachmentActionSheet()
        default: ()
        }
        tableView.deselectRow(at: indexPath, animated: true)
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

extension FeedbackViewController: UserEmailCellEventProtocol {
    func userEmailTextDidChange(_ text: String?) {
        feedbackEditingService.update(userEmailText: text)
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
    func showImage(of item: AttachmentItem) {
        // Pending
    }
}

extension FeedbackViewController {
    private func configureLeftBarButtonItem() {
        if let navigationController = navigationController {
            if navigationController.viewControllers[0] === self {
                navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                   target: self,
                                                                   action: #selector(cancelButtonTapped(_:)))
            } else {
                // Keep the standard back button instead of "Cancel"
                navigationItem.leftBarButtonItem = .none
            }
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: self,
                                                               action: #selector(cancelButtonTapped(_:)))
        }
    }

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

    @objc func cancelButtonTapped(_ sender: Any) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.first === self {
                // Can't pop, just dismiss
                dismiss(animated: true)
            } else {
                // Can be popped
                navigationController.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true)
        }
    }

    @objc func mailButtonTapped(_ sender: Any) {
        do {
            let feedback: Feedback
                = try feedbackEditingService.generateFeedback(configuration: configuration)
            if let action = replacedFeedbackSendingAction {
                action(feedback)
            } else {
                createMail(with: feedback)
            }
        } catch {
            showFeedbackGenerationError()
        }
    }

    private func createMail(with feedback: Feedback) {
        guard MFMailComposeViewController.canSendMail() else { return showMailConfigurationError() }
        let controller: MFMailComposeViewController = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        controller.setToRecipients(feedback.to)
        controller.setCcRecipients(feedback.cc)
        controller.setBccRecipients(feedback.bcc)
        controller.setSubject(feedback.subject)
        controller.setMessageBody(feedback.body, isHTML: feedback.isHTML)
        if let jpeg = feedback.jpeg {
            controller.addAttachmentData(jpeg, mimeType: "image/jpeg", fileName: "screenshot.jpg")
        } else if let mp4 = feedback.mp4 {
            controller.addAttachmentData(mp4, mimeType: "video/mp4", fileName: "screenshot.mp4")
        }
        present(controller, animated: true)
    }

    private func showFeedbackGenerationError() {
        let alertController
            = UIAlertController(title: CTLocalizedString("CTFeedback.Error"),
                                message:
                                CTLocalizedString("CTFeedback.FeedbackGenerationErrorMessage"),
                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Dismiss"),
                                                style: .cancel))
        present(alertController, animated: true)
    }

    private func showMailConfigurationError() {
        let alertController
            = UIAlertController(title: CTLocalizedString("CTFeedback.Error"),
                                message:
                                CTLocalizedString("CTFeedback.MailConfigurationErrorMessage"),
                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Dismiss"),
                                                style: .cancel))
        present(alertController, animated: true)
    }

    private func showAttachmentActionSheet() {
        let alertController = UIAlertController(title: .none,
                                                message: .none,
                                                preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(
                UIAlertAction(title: CTLocalizedString("CTFeedback.PhotoLibrary"),
                              style: .default) { _ in self.showImagePicker(sourceType: .photoLibrary) })
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(
                UIAlertAction(title: CTLocalizedString("CTFeedback.Camera"),
                              style: .default) { _ in self.showImagePicker(sourceType: .camera) })
        }
        if feedbackEditingService.hasAttachedMedia {
            alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Delete"),
                                                    style: .destructive) { _ in
                self.feedbackEditingService.update(attachmentMedia: .none)
            })
        }
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Cancel"),
                                                style: .cancel))
        present(alertController, animated: true)
    }

    private func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .formSheet
        let presentation = imagePicker.popoverPresentationController
        presentation?.permittedArrowDirections = .any
        presentation?.sourceView = view
        presentation?.sourceRect = view.frame
        present(imagePicker, animated: true)
    }

    private func showMailComposingError(_ error: NSError) {
        let alertController = UIAlertController(title: CTLocalizedString("CTFeedback.Error"),
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Dismiss"),
                                                style: .cancel))
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

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        var completion: (() -> ())? = {
            if self.presentingViewController?.presentedViewController != .none {
                self.dismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }

            if result == .failed,
               let error = error as NSError?,
               let callback = self.feedbackDidFailed {
                callback(result, error)
            }
        }

        if result == .cancelled {
            completion = .none
        } else if result == .failed, let error = error as NSError? {
            showMailComposingError(error)
        }

        dismiss(animated: true, completion: completion)
    }
}
