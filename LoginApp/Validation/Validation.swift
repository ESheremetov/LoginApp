//
//  Validation.swift
//  LoginApp
//
//  Created by Егор Шереметов on 26.05.2022.
//

import Foundation


func emailValidation(_ email: String) -> Bool {
    let pattern = #"^\S+@\S+\.\S+$"#
    let result = email.range(
        of: pattern,
        options: .regularExpression
    )
    return result != nil
}

func passwordValidation(_ password: String) -> Bool {
    return password.count > 3
}
