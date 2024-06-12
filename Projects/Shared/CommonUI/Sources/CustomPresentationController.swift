//
//  CustomPresentationController.swift
//  SharedCommonUI
//
//  Created by Chan on 6/11/24.
//

import UIKit

public class CustomPresentationController: UIPresentationController {
    
    private var dimmingView: UIView!
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let height = containerView.bounds.height / 3
        let yOffset = containerView.bounds.height - height
        
        return CGRect(x: 0, y: yOffset, width: containerView.bounds.width, height: height)
    }
    
    public override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        self.dimmingView = UIView(frame: containerView.bounds)
        self.dimmingView.backgroundColor = .clear
        self.dimmingView.alpha = 0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.dimmingView.addGestureRecognizer(tapGestureRecognizer)
        
        containerView.addSubview(self.dimmingView)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.self.dimmingView.alpha = 1
            }, completion: nil)
        } else {
            self.dimmingView.alpha = 1
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0
            }, completion: { _ in
                self.dimmingView.removeFromSuperview()
            })
        } else {
            self.dimmingView.alpha = 0
            self.dimmingView.removeFromSuperview()
        }
    }
    
    @objc private func dismissController() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.dimmingView.frame = containerView?.bounds ?? .zero
    }
}
