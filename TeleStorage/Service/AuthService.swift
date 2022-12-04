//
//  AuthService.swift
//  TeleStorage
//
//  Created by Alexey Kirpichnikov on 2022-11-27.
//

import Foundation
import TDLibKit

protocol AuthServiceDelegate/*: AnyObject*/ {
    func waitPhoneNumer()
    func waitCode()
    func waitPassword()
    func waitEmailAddress()
    func waitEmailCode()
    func onReady()
    func onError(_ error: Swift.Error)
}

class AuthService: UpdateListener {
    
    private let api: TdApi
    private var authorizationState: AuthorizationState?
    
    private(set) var isAuthorized: Bool = false
    // Тут будет возникать retain cycle,
    // нужно это будет зафиксить:
    var delegate: AuthServiceDelegate?
    
    // MARK: - Init
    
    init(api: TdApi) {
        self.api = api
    }
    
    func onUpdate(_ update: Update) {
        if case .updateAuthorizationState(let state) = update {
            do {
                try onUpdateAuthorizationState(state.authorizationState)
            } catch {
                print(error)
            }
        }
    }
    
    func sendPhone(_ phone: String) {
        let settings = PhoneNumberAuthenticationSettings(
            allowFlashCall: false,
            allowMissedCall: false,
            allowSmsRetrieverApi: false,
            authenticationTokens: [],
            isCurrentPhoneNumber: false
        )
        try? self.api.setAuthenticationPhoneNumber(
            phoneNumber: phone,
            settings: settings) { [weak self] in
                self?.chekResult($0)
            }
    }
    
    func sendCode(_ code: String) {
        try? self.api.checkAuthenticationCode(code: code) { [weak self] in
            self?.chekResult($0)
        }
    }
    
    func sendPassword(_ password: String) {
        try? self.api.checkAuthenticationPassword(password: password) { [weak self] in
            self?.chekResult($0)
        }
    }
    
    public func logout() {
        try? self.api.logOut() { [weak self] in
            self?.chekResult($0)
        }
    }
    
    // MARK: - Private methods
    
    private func onUpdateAuthorizationState(_ state: AuthorizationState) throws {
            authorizationState = state
            
            switch state {
            case .authorizationStateWaitTdlibParameters:
                guard let cachesUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                    return
                }
                let tdlibPath = cachesUrl.appendingPathComponent("tdlib", isDirectory: true).path
                let params = SetTdlibParameters(
                    apiHash: "5e6d7b36f0e363cf0c07baf2deb26076", // https://core.telegram.org/api/obtaining_api_id // нужно заменить!!!
                    apiId: 287311,
                    applicationVersion: "1.0",
                    databaseDirectory: tdlibPath,
                    databaseEncryptionKey: Data(),
                    deviceModel: "iOS",
                    enableStorageOptimizer: true,
                    filesDirectory: "",
                    ignoreFileNames: true,
                    systemLanguageCode: "en",
                    systemVersion: "Unknown",
                    useChatInfoDatabase: true,
                    useFileDatabase: true,
                    useMessageDatabase: true,
                    useSecretChats: true,
                    useTestDc: false)

                try api.setTdlibParameters(apiHash: params.apiHash, apiId: params.apiId, applicationVersion: params.applicationVersion, databaseDirectory: params.databaseDirectory, databaseEncryptionKey: params.databaseEncryptionKey, deviceModel: params.deviceModel, enableStorageOptimizer: params.enableStorageOptimizer, filesDirectory: params.filesDirectory, ignoreFileNames: params.ignoreFileNames, systemLanguageCode: params.systemLanguageCode, systemVersion: params.systemVersion, useChatInfoDatabase: params.useChatInfoDatabase, useFileDatabase: params.useFileDatabase, useMessageDatabase: params.useMessageDatabase, useSecretChats: params.useSecretChats, useTestDc: params.useTestDc, completion: { [weak self] (result) in
                    self?.chekResult(result)
                })
                
            case .authorizationStateWaitPhoneNumber:
                delegate?.waitPhoneNumer()
                
            case .authorizationStateWaitCode:
                delegate?.waitCode()
                
            case .authorizationStateWaitPassword(_):
                delegate?.waitPassword()
                
            case .authorizationStateReady:
                isAuthorized = true
                delegate?.onReady()
                
            case .authorizationStateLoggingOut:
                isAuthorized = false
                
            case .authorizationStateClosing:
                isAuthorized = false
                
            case .authorizationStateClosed:
                // TODO: close client
                break
                
            case .authorizationStateWaitRegistration:
                break
                
            case .authorizationStateWaitOtherDeviceConfirmation(_):
                break
            case .authorizationStateWaitEmailAddress(_):
                delegate?.waitEmailAddress()
            case .authorizationStateWaitEmailCode(_):
                delegate?.waitEmailCode()
            }
        }
    
}

extension AuthService {
    
    private func chekResult(_ result: Result<Ok, Swift.Error>) {
        switch result {
        case .success:
            // result is already received through UpdateAuthorizationState, nothing to do
            break
        case .failure(let error):
            delegate?.onError(error)
        }
    }
    
}
