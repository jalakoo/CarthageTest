//
//  TealiumLoggerModule.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/5/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

let tealiumModuleLoggerName = "logger"


extension Tealium {
    
    func getLogLevel() -> LogLevel {
        return (logger()?.logThreshold)!
    }
    
    func setLogLevel(logLevel: LogLevel) {
        logger()?.logThreshold = logLevel
    }
    
    fileprivate func logger() -> TealiumLogger? {
        
        guard let module = modulesManager.getModule(forName: tealiumModuleLoggerName) as? TealiumLoggerModule else {
            return nil
        }
        
        return module.logger
        
    }
    
}

extension TealiumConfig {
    
    @available(*, deprecated, message: "Use the Tealium.getLogLevel() API instead.")
    func getLogLevel() -> LogLevel {
        
        // Stub - Config can no longer access log levels.
        return .none
        
    }
    
    @available(*, deprecated, message: "Use the Tealium.setLogLevel() API instead.")
    func setLogLevel(logLevel: LogLevel) {
        
        // Do nothing - Config can no longer manipulate log levels.
        
    }
    

    
}

enum TealiumLoggerModuleError : Error {

    case moduleDisabled
    case noAccount
    case noProfile
    case noEnvironment
    
}

class TealiumLoggerModule : TealiumModule {
    
    var logger : TealiumLogger?

    override func moduleConfig() -> TealiumModuleConfig {
        return TealiumModuleConfig(name: tealiumModuleLoggerName,
                                   priority: 100,
                                   enabled: true)
    }
    
    override func enable(config:TealiumConfig) {
        
        if logger == nil {

            let id = "\(config.account):\(config.profile):\(config.environment)"
        
            logger = TealiumLogger(loggerId: id, logLevel: .verbose)
        }
        
        didFinishEnable(config: config)

    }
    
    override func disable() {
        
        logger = nil
        
        didFinishDisable()

    }
    
    override func process(originatingModule: TealiumModule,
                          message: String,
                          completion:((_ success: Bool, _ error: Error?)->Void)?) {
        
        if logger != nil {
            
            let newMessage = "\(originatingModule.moduleConfig().name): \(message)"
            let _ = logger?.log(message: newMessage, logLevel: .verbose)
            completion?(true, nil)
            
        } else {
            completion?(false, TealiumLoggerModuleError.moduleDisabled)
        }
        
        didFinishProcess(originatingModule: originatingModule,
                         message: message)
        
    }
    
}
