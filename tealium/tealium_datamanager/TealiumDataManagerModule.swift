//
//  TealiumDataManagerModule.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/7/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

let tealiumModuleDataManagerName = "datamanager"

extension Tealium {

    /**
     Get the Data Manager instance for accessing file persistence and auto data variable APIs.
     */
    func getDataManager() -> TealiumDataManager? {

        guard let dataManagerModule = modulesManager.getModule(forName: tealiumModuleDataManagerName) as? TealiumDataManagerModule else {
            return nil
        }
        
        return dataManagerModule.dataManager
    }
    
}

enum TealiumDataManagerModuleErrors: Error {
    case unknown
    case dataManagerNotInitialized
}


class TealiumDataManagerModule : TealiumModule {
    
    var dataManager : TealiumDataManager?
    
    override func moduleConfig() -> TealiumModuleConfig {
        return  TealiumModuleConfig(name: tealiumModuleDataManagerName,
                                    priority: 500,
                                    enabled: true)
    }
    
    override func enable(config:TealiumConfig) {
        
        do {
            
            try dataManager = TealiumDataManager(account: config.account, profile: config.profile, environment: config.environment)
            delegate?.tealiumModuleRequestsProcessing(module: self, message: "Processing mode: \(dataManager!.persistenceMode().description)")
            didFinishEnable(config: config)
        } catch let error {
            didFailToEnable(config: config, error: error)
        }
        

    }
    
    override func disable() {
        
        dataManager = nil
        
        didFinishDisable()
    }
    
    override func track(data: [String : AnyObject],
                        info: [String : AnyObject]?,
                        completion: ((Bool, [String:AnyObject]?, Error?) -> Void)?) {
        
        guard let dataManager = dataManager else {
            
            // Data Manager not available, pass the call to the next module
            delegate?.tealiumModuleRequestsProcessing(module: self, message: "Not yet ready.")

            // Report issue
            delegate?.tealiumModuleFailedToTrack(module: self,
                                                 data: data,
                                                 info: info,
                                                 error: nil, completion: completion)
            
            // Return completion block
            completion?(false, nil, TealiumDataManagerModuleErrors.dataManagerNotInitialized)
            
            return
        }

        var dataDictionary = [String:AnyObject]()

        dataDictionary += dataManager.getVolatileData()
        dataDictionary += dataManager.getPersistentData()!
        dataDictionary += data
        
        didFinishTrack(data: dataDictionary,
                       info: info,
                       completion : completion)
        
    }
    
}
