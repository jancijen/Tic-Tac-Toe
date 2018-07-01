//
//  TwoChoicesViewController.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 1.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import UIKit

/// View controller used for screen with 2 choices.
class TwoChoicesViewController: UIViewController {
    // MARK: - Public attributes
    var choice1Callback: (() -> Void)? = nil
    var choice2Callback: (() -> Void)? = nil
    
    // MARK: - Private attributes
    let choiceTitle: String
    let choice1: String
    let choice2: String
    
    // MARK: - Public methods
    init(title: String, choice1: String, choice2: String) {
        self.choiceTitle = title
        self.choice1 = choice1
        self.choice2 = choice2
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // Choice 1
        let choice1Button = UIButton()
        choice1Button.backgroundColor = ThemeManager.menuButtonColor
        choice1Button.setTitleColor(.white, for: .normal)
        choice1Button.setTitle(choice1, for: .normal)
        
        choice1Button.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        // Choice 2
        let choice2Button = UIButton()
        choice2Button.backgroundColor = ThemeManager.menuButtonColor
        choice2Button.setTitleColor(.white, for: .normal)
        choice2Button.setTitle(choice2, for: .normal)
        
        choice2Button.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        // Stack view with both choices
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16.0
        
        stackView.addArrangedSubview(choice1Button)
        stackView.addArrangedSubview(choice2Button)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
