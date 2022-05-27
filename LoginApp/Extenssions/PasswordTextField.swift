//
//  PasswordTextField.swift
//  LoginApp
//
//  Created by Егор Шереметов on 26.05.2022.
//

import Foundation
import UIKit


extension UITextField {
    
    func addSecureButton() {
        let button = UIButton(type: .custom)
        
        button.alpha = 0.5
        button.addTarget(self, action: #selector(togglePasswordView(_:)), for: .touchDown)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0)
        button.configuration = configuration
        
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
                
        rightView = button
        rightViewMode = .always
    }

    @objc func togglePasswordView(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        isSecureTextEntry.toggle()
        button.isSelected.toggle()
    }
}
