//
//  ContentView.swift
//  TeleStorage
//
//  Created by Alexey Kirpichnikov on 2022-11-27.
//

import SwiftUI

struct AuthView: View {
    
    @State private var phone: String = ""
    @State private var code: String = ""
    @State private var password: String = ""
    
    @State var showPhone = false
    @State var showCode = false
    @State private var showPassword = false
    
    private var authService = ServiceLayer.instance.authService
    
    init(phone: String, code: String, password: String, authService: AuthService = ServiceLayer.instance.authService) {
        self.phone = phone
        self.code = code
        self.password = password
        self.authService = authService
        
        self.authService.delegate = self
        ServiceLayer.instance.telegramService.run()
        //activity indicator stop
    }

    var body: some View {
        VStack {
            
            if showPhone {
                TextField("Phone:", text: $phone)
                Button("Next") {
                    print("--->>> Phone Next")
                }
            }
            
            if showCode {
                TextField("Code:", text: $code)
                Button("Next") {
                    print("--->>> Code Next")
                }
            }
            
            if showPassword {
                TextField("Password:", text: $password)
                Button("Next") {
                    print("--->>> Password Next")
                }
            }
        }.padding(20)
    }
    
    private func sendPhone() {
        guard !phone.isEmpty else { return }
        print("--->>> send phone func ...")
        authService.sendPhone(phone)
    }
    
    private func sendCode() {
        guard !code.isEmpty else { return }
        print("--->>> send code func ...")
        authService.sendCode(code)
    }
    
    private func sendPassword() {
        guard !password.isEmpty else { return }
        print("--->>> send password func ...")
        authService.sendPassword(password)
    }
}

extension AuthView: AuthServiceDelegate {
    func waitPhoneNumer() {
        showPhone = false
        showCode = true
        showPassword = true
        //activityIndicator.stopAnimating()
    }
    
    func waitCode() {
        showPhone = false
        showCode = true
        showPassword = false
        //activityIndicator.stopAnimating()
    }
    
    func waitPassword() {
        showPhone = false
        showCode = false
        showPassword = true
        //activityIndicator.stopAnimating()
    }
    
    func waitEmailAddress() {
        // not used yet
    }
    
    func waitEmailCode() {
        // not used yet
    }
    
    func onReady() {
        // Routing to the main view
    }
    
    func onError(_ error: Error) {
        // present error alert
    }
    
    
}

