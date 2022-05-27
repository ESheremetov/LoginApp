//
//  BasicAuth.swift
//  LoginApp
//
//  Created by Егор Шереметов on 26.05.2022.
//

import Foundation
import RxCocoa
import RxSwift


fileprivate struct TokenResponse: Decodable {
    let accessToken: String
}


class BasicAuth {
    
    var urlString: String?
    
    var isSignIn = PublishSubject<Bool>()
    var isError = PublishSubject<Bool>()
    
    init(for urlString: String) {
        self.urlString = urlString
    }
    
    func login(with email: String, password: String) {
        guard let urlString = urlString, !urlString.isEmpty else { return }
        let loginString = "\(email):\(password)"
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { [ weak self ] data, response, error in
            DispatchQueue.main.async {
                if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                    self?.isError.onNext(true)
                } else if let data = data {
                    do {
                        let response = try JSONDecoder().decode(TokenResponse.self, from: data)
                        let keyChainItemQuery = [
                            kSecValueData: response.accessToken.data(using: .utf8)!,
                            kSecClass: kSecClassGenericPassword] as CFDictionary
                        let _ = SecItemAdd(keyChainItemQuery, .none)
                        self?.isSignIn.onNext(true)
                    } catch {
                        self?.isError.onNext(true)
                        print("Unable to decode response: \(error)")
                    }
                }
            }
        }.resume()
    }
}


