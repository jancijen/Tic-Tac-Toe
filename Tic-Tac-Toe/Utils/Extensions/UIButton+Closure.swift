//
//  UIButton+Closure.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 5.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// Closure typealias.
typealias UIButtonTargetClosure = () -> Void

// MARK: - ClosureWrapper

/// Closure wrapper class.
class ClosureWrapper {
    // MARK: Public properties
    
    let closure: UIButtonTargetClosure
    
    // MARK: Initialization
    
    /**
     Initializes new closure wrapper.
     
     - parameter closure: Closure to be wrapped.
     */
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

// MARK: - UIButton

/// Extending UIButton to be able to use closure as button's target.
extension UIButton {
    // MARK: AssociatedKeys
    
    /// Struct with keys for associated objects.
    private struct AssociatedKeys {
        // MARK: Public properties
        
        static var targetClosure = "targetClosure"
    }
    
    // MARK: Private properties
    
    /// (Optional) Property holding closure to be called as a result of specific button action.
    private var targetClosure: UIButtonTargetClosure? {
        get {
            // Try to get closure from associated objects and return it
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            // Check new value
            guard let newValue = newValue else { return }
            // Set new value as an associated object
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: Public methods
    
    /**
     Adds closure as button's target.
     
     - parameter actionClosure: Closure to be set as button's target.
     - parameter controlEvents: A bitmask specifying the control-specific events for which the action closure is called.
     
     - returns: Application font with given size.
     */
    func addTargetClosure(actionClosure: @escaping UIButtonTargetClosure, for controlEvents: UIControlEvents) {
        // Set closure
        targetClosure = actionClosure
        // Add target using "wrapper" method
        addTarget(self, action: #selector(triggerClosureAction), for: controlEvents)
    }
    
    // MARK: Private methods
    
    /**
     Triggers closure action.
     */
    @objc private func triggerClosureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure()
    }
}
