//
//  Poppable.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 5.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

// MARK: - Poppable

/// Protocol defining required methods and attributes of poppable element.
protocol Poppable {
    // MARK: Methods
    func show(animated: Bool) -> Void
    func dismiss(animated: Bool) -> Void
    
    // MARK: Properties
    var alertView: UIView { get }
    var backgroundView: UIView { get }
}

// MARK: - Poppable: UIView

extension Poppable where Self: UIView {
    /**
     Show poppable view.
     
     - parameter animated: Whether show should be animated.
     */
    func show(animated: Bool) {
        // Initial view setup before showing
        backgroundView.alpha = 0
        alertView.center = CGPoint(x: self.center.x, y: self.frame.height * 2)
        
        // Add view as a subview
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        
        // Animated
        if animated {
            // Background view - show with animation
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            
            // Alert view - show with animation
            UIView.animate(withDuration: 0.33, delay: 1.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { [unowned self] in
                self.alertView.center = self.center
            })
        }
        // Non-animated
        else {
            // Show without animation
            self.backgroundView.alpha = 0.66
            self.alertView.center  = self.center
        }
    }
    
    /**
     Dismiss poppable view.
     
     - parameter animated: Whether dismiss should be animated.
     */
    func dismiss(animated: Bool) {
        // Animated
        if animated {
            // Background view - dismiss with animation
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            })
            
            // Alert view - dismiss with animation
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.alertView.center = CGPoint(x: self.center.x, y: self.frame.height + self.alertView.frame.height/2)
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
        }
        // Non-animated
        else {
            // Dismiss without animation
            self.removeFromSuperview()
        }
        
    }
}
