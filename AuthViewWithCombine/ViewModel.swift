//
//  ViewModel.swift
//  AuthViewWithCombine
//
//  Created by Никитин Артем on 7.07.23.
//

import Foundation
import Combine


final class ViewModel: ObservableObject {
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var canSubmit = false
    
    @Published private var isValidEmail = false
    @Published private var isValidPhone = false
    @Published private var isValidPassword = false
    
    var emailPrompt: String? {
        if email.isEmpty || isValidEmail == true {
            return nil
        } else {
            return "Enter valid email. Prompt: test@test.com"
        }
    }
    
    var phonePrompt: String? {
        if phone.isEmpty || isValidPhone == true {
            return nil
        } else {
            return "Enter valid phone."
        }
    }
    
    var passwordPrompt: String? {
        if password.isEmpty || isValidPassword == true {
            return nil
        } else {
            return "Enter valid password."
        }
    }
    
    private let emailPredicate = NSCompoundPredicate(format: "SELF MATCHES %@", Regex.email.rawValue)
    private let phonePredicate = NSCompoundPredicate(format: "SELF MATCHES %@", Regex.phone.rawValue)
    
    private var cancellable: Set<AnyCancellable> = []
    
    init() {
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { email in
                return self.emailPredicate.evaluate(with: email)
            }
            .assign(to: \.isValidEmail, on: self)
            .store(in: &cancellable)
        
        $phone
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { phone in
                return self.phonePredicate.evaluate(with: phone)
            }
            .assign(to: \.isValidPhone, on: self)
            .store(in: &cancellable)
        
        $password
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { password in
                return password.count >= 8            }
            .assign(to: \.isValidPassword, on: self)
            .store(in: &cancellable)
        
        Publishers.CombineLatest3($isValidEmail, $isValidPhone, $isValidPassword)
            .map { email, phone, password in
                    return (email && phone && password)
            }
            .assign(to: \.canSubmit, on: self)
            .store(in: &cancellable)
    }
}
