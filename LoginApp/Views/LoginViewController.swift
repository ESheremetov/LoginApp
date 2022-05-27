//
//  LoginViewController.swift
//  LoginApp
//
//  Created by Егор Шереметов on 26.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: LoginFieldsView!
    
    weak var loadSpinner: UIView?
    
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.loginView.setLoginAction(self.loginAction)
        self.loginView.setRegistrationAction(self.registrationAction)
        self.loginView.setForgotPasswordAction(self.forgotPasswordAction)
        self.loginView.setEditLoginAction(self.toggleEdit)
        
        self.loginView.loginTextField.rx.text.map { $0 ?? "" }.bind(to: self.viewModel.email).disposed(by: disposeBag)
        self.loginView.passwordTextField.rx.text.map { $0 ?? "" }.bind(to: self.viewModel.password).disposed(by: disposeBag)

        self.viewModel.isValid.bind(to: self.loginView.loginButton.rx.isEnabled).disposed(by: disposeBag)
        self.viewModel.isValid.map { $0 ? 1 : 0.25 }.bind(to: self.loginView.loginButton.rx.alpha).disposed(by: disposeBag)
        
        self.viewModel.isError.subscribe { [weak self] (event) in
            guard let value = event.element else { return }
            guard let self = self else { return }
            self.loginView.loginTextField.layer.borderColor = value ? UIColor.red.cgColor : UIColor.lightGray.cgColor
            self.loginView.loginTextField.backgroundColor = value ? UIColor(red: 200, green: 0, blue: 0, alpha: 0.1) : .white
            self.cancelLoadingIndicator()
        }.disposed(by: disposeBag)
        
        self.viewModel.isSignIn.subscribe { [weak self] (event) in
            guard let self = self else { return }
            self.cancelLoadingIndicator()
        }.disposed(by: disposeBag)
    }
    
    func toggleEdit() {
        self.viewModel.isError.onNext(false)
    }
    
    func showLoadingIndicator() {
        let spinnerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        spinnerView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 1.5)
        spinnerView.layer.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 0.5).cgColor
        spinnerView.layer.opacity = 0.5
        spinnerView.clipsToBounds = true
        
        spinnerView.layer.cornerRadius = 20.0
        
        let indicator = UIActivityIndicatorView.init(style: .large)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = CGPoint(x: (spinnerView.frame.width) / 2, y: (spinnerView.frame.height) / 2)
        indicator.color = UIColor(red: 48, green: 176, blue: 199, alpha: 100)
        
        indicator.startAnimating()
        DispatchQueue.main.async { [ unowned self ] in
            spinnerView.addSubview(indicator)
            self.view.addSubview(spinnerView)
        }
        
        self.loadSpinner = spinnerView
    }
    
    func cancelLoadingIndicator() {
        DispatchQueue.main.async { [ unowned self ] in
            self.loadSpinner?.removeFromSuperview()
            self.loadSpinner = nil
        }
    }
    
    func loginAction() {
        self.showLoadingIndicator()
        self.viewModel.isError.onNext(false)
        self.viewModel.login(email: self.loginView.loginTextField.text!,
                             password: self.loginView.passwordTextField.text!)
    }
    
    func registrationAction() {
        self.viewModel.registration()
    }
    
    func forgotPasswordAction() {
        print("Go to next!")
    }
}
