//
//  LoginFieldsView.swift
//  LoginApp
//
//  Created by Егор Шереметов on 26.05.2022.
//

import UIKit

@IBDesignable
class LoginFieldsView: UIView {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard let action = self._loginAction else { return }
        action()
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        guard let action = self._forgotPasswordAction else { return }
        action()
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        guard let action = self._registrationAction else { return }
        action()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private var _loginAction: (() -> ())?
    private var _forgotPasswordAction: (() -> ())?
    private var _registrationAction: (() -> ())?
    private var _editLoginAction: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    func commonInit() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        
        passwordTextField.addSecureButton()
        
        self.loginTextField.layer.borderWidth = 2
        self.loginTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.loginTextField.layer.cornerRadius = 3
        
        self.passwordTextField.layer.borderWidth = 2
        self.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordTextField.layer.cornerRadius = 3
        
        self.loginTextField.addTarget(self, action: #selector(someFunc), for: .editingChanged)
        
        addSubview(view)
    }
    
    @objc private func someFunc() {
        guard let action = self._editLoginAction else { return }
        action()
    }
    
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func setLoginAction(_ action: @escaping () -> ()) {
        self._loginAction = action
    }
    
    func setForgotPasswordAction(_ action: @escaping () -> ()) {
        self._forgotPasswordAction = action
    }
    
    func setRegistrationAction(_ action: @escaping () -> ()) {
        self._registrationAction = action
    }
    
    func setEditLoginAction(_ action: @escaping () -> ()) {
        self._editLoginAction = action
    }
}
