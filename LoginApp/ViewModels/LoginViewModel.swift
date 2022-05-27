//
//  LoginViewModel.swift
//  LoginApp
//
//  Created by Егор Шереметов on 26.05.2022.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel {
    
    typealias Credentials = (email: String, password: String)
    
    let auth: BasicAuth = BasicAuth(for: "http://localhost:5000/api/v1/auth/")
    
    let disposebag: DisposeBag = DisposeBag()
        
    let email = PublishSubject<String>()
    let password = PublishSubject<String>()
    
    let isSignIn = PublishSubject<Bool>()
    let isError = PublishSubject<Bool>()
    
    var isValid: Observable<Bool> {
        get {
            return Observable.combineLatest(self.email.asObservable().startWith(""),
                                            self.password.asObservable().startWith("")).map { email, password in
                return self.validate((email, password))
            }.startWith(false)
        }
    }
    
    init() {
        auth.isSignIn.bind(to: self.isSignIn).disposed(by: disposebag)
        auth.isError.bind(to: self.isError).disposed(by: disposebag)
    }
    
    func login(email: String, password: String) {
        self.auth.login(with: email, password: password)
    }
    
    func registration() {
        print("Registrated!")
    }
    
    func validate(_ creds: Credentials) -> Bool {
        return emailValidation(creds.email) && passwordValidation(creds.password)
    }
}
