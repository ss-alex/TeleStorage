//
//  StdOutLogger.swift
//  TeleStorage
//
//  Created by Alexey on 2022-11-30.
//

import Foundation
import TDLibKit

public final class StdOutLogger: Logger {
    
    let queue: DispatchQueue
    
    public init() {
        queue = DispatchQueue(label: "Logger", qos: .userInitiated)
    }
    
    public func log(_ message: String, type: LoggerMessageType?) {
        queue.async {
            var fisrtLine = "---------------------------"
            if let type = type {
                fisrtLine = ">> \(type.description): ---------------"
            }
            print("""
                \(fisrtLine)
                \(message)
                ---------------------------
                """)
        }
    }
}

