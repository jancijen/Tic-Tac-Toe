//
//  UIButton.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 5.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

typealias UIButtonTargetClosure = () -> ()

/// Closure wrapper class.
class ClosureWrapper {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

/// UIButton extension to be able to use closure as button's target.
extension UIButton {
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(actionClosure: @escaping UIButtonTargetClosure, for controlEvents: UIControlEvents) {
        targetClosure = actionClosure
        addTarget(self, action: #selector(triggerClosureAction), for: controlEvents)
    }
    
    @objc func triggerClosureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure()
    }
}
