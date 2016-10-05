//
//  tealiumLogger.swift
//  tealium-swift
//
//  Created by Jason Koo, Merritt Tidwell, Chad Hartman, Karen Tamayo, Chris Anderberg  on 8/31/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

enum TealiumLogLevelValue {
    static let errors = "errors"
    static let none = "none"
    static let verbose = "verbose"
    static let warnings = "warnings"
}

enum LogLevel {
    case none
    case errors
    case warnings
    case verbose
    
    var description : String {
        switch self {
        case .errors:
            return TealiumLogLevelValue.errors
        case .warnings:
            return TealiumLogLevelValue.warnings
        case .verbose:
            return TealiumLogLevelValue.verbose
        default:
            return TealiumLogLevelValue.none
        }
    }
    
    static func fromString(_ string: String) -> LogLevel {
        switch string.lowercased() {
        case TealiumLogLevelValue.errors:
            return .errors
        case TealiumLogLevelValue.warnings:
            return .warnings
        case TealiumLogLevelValue.verbose:
            return .verbose
        default:
            return .none
        }
    }
}

/**
    Internal console logger for library debugging.
 
 */
class TealiumLogger {
    
    let idString : String
    var logThreshold : LogLevel
    
    init(loggerId: String, logLevel: LogLevel) {
        
        self.idString = loggerId
        self.logThreshold = logLevel
        
    }
    
    func log(message: String, logLevel: LogLevel) -> String? {

        if logThreshold.hashValue >= logLevel.hashValue {
            print("*** TEALIUM SWIFT \(TealiumValue.libraryVersion) *** Instance \(idString): \(message)")
            return message
        }
        return nil
    }
    
}
