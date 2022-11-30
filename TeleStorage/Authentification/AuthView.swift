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

    var body: some View {
        VStack {
            TextField("Phone:", text: $phone)
            Button("Next") {
                print("--->>> Phone Next")
            }
            TextField("Code:", text: $code)
            Button("Next") {
                print("--->>> Code Next")
            }
            TextField("Password:", text: $password)
            Button("Next") {
                print("--->>> Password Next")
            }
        }.padding(20)
    }
    
    private func sendPhone() {
        guard !phone.isEmpty else { return }
        
    }

}

