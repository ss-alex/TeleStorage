//
//  ServiceLayer.swift
//  TeleStorage
//
//  Created by Alexey Kirpichnikov on 2022-11-30.
//

import Foundation

final class ServiceLayer {
    
    static let instance = ServiceLayer()
    
    let telegramService: TelegramService
    let authService: AuthService
    
    private init() {
        let logger = StdOutLogger()
        telegramService = TelegramService(logger: logger)
        authService = AuthService(api: telegramService.api)
        telegramService.add(listener: authService)
    }
}
