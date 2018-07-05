//
//  UIButton.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 5.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// UIButton extensions.
extension UIButton {
    private func closureActionHandler(action: (() -> Void)? = nil) {
        struct closureStruct {
            static var action: (() -> Void)?
        }
        
        // Assign action, if provided
        if let act = action {
            closureStruct.action = act
        } else { // Trigger action
            closureStruct.action?()
        }
    }
    
    @objc private func triggerClosureAction() {
        self.closureActionHandler()
    }
    
    func addTargetClosure(actionClosure: @escaping () -> Void, for controlEvents: UIControlEvents) {
        self.closureActionHandler(action: actionClosure)
        self.addTarget(self, action: #selector(triggerClosureAction), for: controlEvents)
    }
}
