//
//  UserInfo.swift
//  TeleStorage
//
//  Created by Alexey Kirpichnikov on 2022-11-27.
//

import Foundation
import TDLibKit

struct UserInfo {
    
    /// User identifier
    let id: Int64?
    
    /// First name of the user
    let firstName: String?
    
    /// Last name of the user
    let lastName: String?
    
    /// Phone number of the user
    let phoneNumber: String?
    
    /// Username of the user; may be null
    let username: String?
    
    /// True, if the user is a Telegram Premium user
    let isPremium: Bool?
}

extension UserInfo {
    
    init(_ user: User) {
        self.id = user.id
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.phoneNumber = user.phoneNumber
        self.username = user.usernames?.activeUsernames.first
        self.isPremium = user.isPremium
    }
}
