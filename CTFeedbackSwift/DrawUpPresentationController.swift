//
// Created by 和泉田 領一 on 2017/09/17.
// Copyright (c) 2017 CAPH TECH. All rights reserved.
//

import UIKit

class DrawUpPresentationController: UIPresentationController {
    var overlayView: UIView!

    func createOverlayView(withFrame frame: CGRect) -> UIView {
        let view              = UIView(frame: frame)
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(overlayTouched(_:)))
        view.addGestureRecognizer(gestureRecognizer)
        view.backgroundColor = .black
        view.alpha = 0.0
        return view
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }
        overlayView = createOverlayView(withFrame: containerView.bounds)
        containerView.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self]
        context in
            self.overlayView.alpha = 0.5
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            self.overlayView.alpha = 0.0
        })
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }
        overlayView.removeFromSuperview()
        overlayView = .none
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height / 2.0)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerBounds = containerView?.bounds else { return CGRect.zero }
        var result = CGRect.zero
        result.size = size(forChildContentContainer: presentedViewController,
                           withParentContainerSize: containerBounds.size)
        result.origin.y = containerBounds.height - result.height
        return result
    }

    override func containerViewWillLayoutSubviews() {
        guard let containerBounds = containerView?.bounds else { return }
        overlayView.frame = containerBounds
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    @objc func overlayTouched(_ sender: Any) { presentedViewController.dismiss(animated: true) }
}
