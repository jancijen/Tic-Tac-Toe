//
//  AlertView.swift
//  Tic-Tac-Toe
//
//  Created by Jendrusak, Jan on 5.7.18.
//  Copyright © 2018 Jan Jendrusak. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView, Poppable {
    // MARK: - Public attributes
    let backgroundView: UIView = UIView()
    let alertView: UIView = UIView()
    // MARK: - Private attributes
    private let buttonsStack: UIStackView = UIStackView()
    
    // MARK: - Public methods
    convenience init(title: String, image: UIImage?) {
        self.init(frame: UIScreen.main.bounds)
        
        self.setupObservers()
        self.configure(title: title, image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addActionButton(title: String, action: @escaping () -> Void) {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = ThemeManager.appFont(size: ThemeManager.buttonFontSize)
        button.setTitleColor(.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTargetClosure(actionClosure: action, for: .touchUpInside)
        
        self.buttonsStack.addArrangedSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Private methods
    private func configure(title: String, image: UIImage?) {
        alertView.clipsToBounds = true
        
        // -------------- Background view --------------
        self.backgroundView.frame = self.frame
        self.backgroundView.backgroundColor = .black
        self.backgroundView.alpha = 0.6
        
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // -------------- Alert view --------------
        // Title
        let titleLabel = UILabel()
        titleLabel.font = ThemeManager.appFont(size: ThemeManager.titleFontSize)
        titleLabel.text = title
        
        self.alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.alertView.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // Buttons
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .equalSpacing
        buttonsStack.alignment = .center
        buttonsStack.spacing = 10
        
        self.alertView.addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
        }
        
        // Image
        if let img = image {
            let imageView = UIImageView(image: img)
            
            self.alertView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(32)
                make.top.equalTo(titleLabel.snp.bottom).offset(15)
                make.centerX.equalToSuperview()
            }
            
            self.buttonsStack.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(20)
            }
        } else {
            self.buttonsStack.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
            }
        }
        
        // Alert view
        self.alertView.backgroundColor = .white
        self.addSubview(self.alertView)
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(240)
        }
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
}

// MARK: - Observers callbacks
extension AlertView {
    @objc private func rotated() {
        // Reset frame of view
        self.frame = UIScreen.main.bounds
    }
}
