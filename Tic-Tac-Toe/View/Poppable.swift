//
//  Poppable.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 5.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

// MARK: - Poppable
protocol Poppable {
    func show(animated: Bool)
    func dismiss(animated: Bool)
    var backgroundView: UIView { get }
    var alertView: UIView { get }
}

// MARK: - Poppable:UIView
extension Poppable where Self:UIView {
    /**
     Show poppable view.
     */
    func show(animated:Bool) {
        self.backgroundView.alpha = 0
        self.alertView.center = CGPoint(x: self.center.x, y: self.frame.height * 2)
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            
            UIView.animate(withDuration: 0.33, delay: 1.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.alertView.center  = self.center
            }, completion: { (completed) in
                
            })
        } else {
            self.backgroundView.alpha = 0.66
            self.alertView.center  = self.center
        }
    }
    
    /**
     Dismiss poppable view.
     */
    func dismiss(animated:Bool) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: { (completed) in
                
            })
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                self.alertView.center = CGPoint(x: self.center.x, y: self.frame.height + self.alertView.frame.height/2)
            }, completion: { (completed) in
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
        
    }
}
