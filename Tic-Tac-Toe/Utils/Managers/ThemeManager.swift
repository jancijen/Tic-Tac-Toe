//
//  ThemeManager.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 1.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation
import UIKit

/// Class for UI appearance management.
class ThemeManager {
    // MARK: - Public properties
    // Colors
    static let menuButtonColor: UIColor = UIColor.black
    // Fonts
    static let bigTitleFontSize: CGFloat = 80
    static let titleFontSize: CGFloat = 60
    static let buttonFontSize: CGFloat = 30
    
    // MARK - Private properties
    private static let fontName: String = "BebasNeue-Regular"
    
    // MARK: - Public static methods
    /**
     Get application font.
     
     - parameter size: Wanted size of font.
     
     - returns: Application font with given size.
     */
    static func appFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: ThemeManager.fontName, size: size) else {
            fatalError("Failed to load the \(ThemeManager.fontName) font.")
        }
        
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}
