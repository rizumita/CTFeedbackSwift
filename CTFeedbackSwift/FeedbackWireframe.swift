//
// Created by 和泉田 領一 on 2017/09/25.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit
import MobileCoreServices
import MessageUI

protocol FeedbackWireframeProtocol {
    func showTopicsView(with service: FeedbackEditingServiceProtocol)
    func showMailComposer(with feedback: Feedback)
    func showAttachmentActionSheet(authorizePhotoLibrary: @escaping (@escaping (Bool) -> ()) -> (),
                                   authorizeCamera: @escaping (@escaping (Bool) -> ()) -> (),
                                   deleteAction: (() -> ())?)
    func showFeedbackGenerationError()
    func showUnknownErrorAlert()
    func showMailComposingError(_ error: NSError)
    func dismiss(completion: (() -> ())?)
    func pop()
}

final class FeedbackWireframe {
    private weak var viewController:        UIViewController?
    private weak var transitioningDelegate: UIViewControllerTransitioningDelegate?
    private weak var imagePickerDelegate:   (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    private weak var mailComposerDelegate:  MFMailComposeViewControllerDelegate?

    init(viewController: UIViewController,
         transitioningDelegate: UIViewControllerTransitioningDelegate,
         imagePickerDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate,
         mailComposerDelegate: MFMailComposeViewControllerDelegate) {
        self.viewController = viewController
        self.transitioningDelegate = transitioningDelegate
        self.imagePickerDelegate = imagePickerDelegate
        self.mailComposerDelegate = mailComposerDelegate
    }
}

extension FeedbackWireframe: FeedbackWireframeProtocol {
    func showTopicsView(with service: FeedbackEditingServiceProtocol) {
        let controller = TopicsViewController(service: service)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = transitioningDelegate

        DispatchQueue.main.async { self.viewController?.present(controller, animated: true) }
    }

    func showMailComposer(with feedback: Feedback) {
        guard MFMailComposeViewController.canSendMail() else { return showMailConfigurationError() }
        let controller: MFMailComposeViewController = MFMailComposeViewController()
        controller.mailComposeDelegate = mailComposerDelegate
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
        viewController?.present(controller, animated: true)
    }

    func showAttachmentActionSheet(authorizePhotoLibrary: @escaping (@escaping (Bool) -> ()) -> (),
                                   authorizeCamera: @escaping (@escaping (Bool) -> ()) -> (),
                                   deleteAction: (() -> ())?) {
        let alertController = UIAlertController(title: .none,
                                                message: .none,
                                                preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(
                UIAlertAction(title: CTLocalizedString("CTFeedback.PhotoLibrary"),
                              style: .default) { _ in
                    authorizePhotoLibrary { granted in
                        if granted {
                            self.showImagePicker(sourceType: .photoLibrary)
                        } else {
                            self.showPhotoLibraryAuthorizingAlert()
                        }
                    }
                })
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(
                UIAlertAction(title: CTLocalizedString("CTFeedback.Camera"),
                              style: .default) { _ in
                    authorizeCamera { granted in
                        if granted {
                            self.showImagePicker(sourceType: .camera)
                        } else {
                            self.showCameraAuthorizingAlert()
                        }
                    }
                })
        }

        if let delete = deleteAction {
            alertController.addAction(
                UIAlertAction(title: CTLocalizedString("CTFeedback.Delete"),
                              style: .destructive) { _ in delete() })
        }

        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Cancel"),
                                                style: .cancel))
        let screenSize = UIScreen.main.bounds
        alertController.popoverPresentationController?.sourceView = viewController?.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height/2, width: 0, height: 0)
        alertController.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)

        viewController?.present(alertController, animated: true)
    }

    func showFeedbackGenerationError() {
        let alertController
            = UIAlertController(title: CTLocalizedString("CTFeedback.Error"),
                                message:
                                CTLocalizedString("CTFeedback.FeedbackGenerationErrorMessage"),
                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Dismiss"),
                                                style: .cancel))
        viewController?.present(alertController, animated: true)
    }

    func showUnknownErrorAlert() {
        let title           = CTLocalizedString("CTFeedback.UnknownError")
        let alertController = UIAlertController(title: title,
                                                message: .none,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Dismiss"),
                                                style: .default))
        viewController?.present(alertController, animated: true)
    }

    func showMailComposingError(_ error: NSError) {
        let alertController = UIAlertController(title: CTLocalizedString("CTFeedback.Error"),
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Dismiss"),
                                                style: .cancel))
        viewController?.present(alertController, animated: true)
    }

    func dismiss(completion: (() -> ())?) {
        viewController?.dismiss(animated: true, completion: completion)
    }

    func pop() { viewController?.navigationController?.popViewController(animated: true) }
}

private extension FeedbackWireframe {
    func showMailConfigurationError() {
        let alertController
            = UIAlertController(title: CTLocalizedString("CTFeedback.Error"),
                                message:
                                CTLocalizedString("CTFeedback.MailConfigurationErrorMessage"),
                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: CTLocalizedString("CTFeedback.Dismiss"),
                                                style: .cancel))
        viewController?.present(alertController, animated: true)
    }

    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.allowsEditing = false
        imagePicker.delegate = imagePickerDelegate
        imagePicker.modalPresentationStyle = .formSheet
        let presentation = imagePicker.popoverPresentationController
        presentation?.permittedArrowDirections = .any
        presentation?.sourceView = viewController?.view
        presentation?.sourceRect = viewController?.view.frame ?? CGRect.zero
        viewController?.present(imagePicker, animated: true)
    }

    func showPhotoLibraryAuthorizingAlert() {
        let alert = UIAlertController(title: .none,
                                      message: CTLocalizedString("CTFeedback.requiredLibraryAccess"),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }))
        viewController?.present(alert, animated: true)
    }

    func showCameraAuthorizingAlert() {
        let alert = UIAlertController(title: .none,
                                      message: CTLocalizedString("CTFeedback.requiredCameraAccess"),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }))
        viewController?.present(alert, animated: true)
    }
}
