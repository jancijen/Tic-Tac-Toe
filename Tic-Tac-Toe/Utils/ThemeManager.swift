//
//  ThemeManager.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 1.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation
import UIKit

// TODO - Singleton?

/// Class for UI appearance management.
class ThemeManager {
    // MARK - Private attributes
    static let fontName = "BebasNeue-Regular"
    
    // MARK: - Public attributes
    static let menuButtonColor = UIColor.black
    
    // MARK: - Public methods
    static func appFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: ThemeManager.fontName, size: size) else {
            fatalError("Failed to load the \(ThemeManager.fontName) font.")
        }
        
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}
