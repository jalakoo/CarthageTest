//
//  TealiumIOManager.swift
//  tealium-swift
//
//  Created by Chad Hartman on 9/2/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

enum TealiumIOManagerError: Error {
    case cannotPersistData
}

enum TealiumIOManagerPersistenceMode {
    case none
    case file
    case defaults
    
    var description: String {
        switch self {
        case .file:
            return "file"
        case .defaults:
            return "defaults"
        default:
            return "none"
        }
    }
}

/**
    Internal persistent data handler.
 
 */
class TealiumIOManager {
    
    var persistenceMode = TealiumIOManagerPersistenceMode.file
    var defaultsManager : TealiumDefaultsManager?
    var fileManager : TealiumFileManager?
    
    /**
     Initializer.
     
     - Parameters:
         - account: Tealium account name.
         - profile: Tealium profile name.
         - env: Tealium environment name (dev, qa, prod).
         - completion: Closure executed with init is complete. Nil returned if successful.
     */
    init(account:String, profile:String, env: String) throws {
        
        do {
            try fileManager = TealiumFileManager(account: account, profile: profile, env: env)
            persistenceMode = TealiumIOManagerPersistenceMode.file
            
        } catch _ {
            
            // Attempt defaults -- Nested try-catches... wonderful.
            do {
                try defaultsManager = TealiumDefaultsManager(account: account, profile: profile, env: env)
                persistenceMode = TealiumIOManagerPersistenceMode.defaults
                
            } catch _ {
                throw TealiumIOManagerError.cannotPersistData
            }
            
        }
        
    }
    
    /**
     Determine whether existing data is saved at ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Returns: true if the file exists.
     */
    func persistedDataExists() -> Bool {
        
        if persistenceMode == .file {
            return (fileManager?.persistedDataExists())!
        } else {
            return (defaultsManager?.persistedDataExists())!
        }
    }
    
    /**
     Persists a [String:AnyObject] instance to ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Parameters:
     - data: The desired data to persist, clobbers the previously saved file.
     */
    func saveData(_ data:[String:AnyObject]) {
        
        if persistenceMode == .file {
            fileManager?.saveData(data)
        } else {
            defaultsManager?.saveData(data: data)
        }
    }
    
    /**
     Loads persisted data from ~/.tealium/swift/{account}_{profile}_{env}.data if it exists.
     
     - Returns: [String:AnyObject] data if exists, otherwise null if not present or corrupted.
     */
    func loadData() -> [String:AnyObject]? {
        
        if persistenceMode == .file {
            
            return loadFileData()
            
        } else {
            
            return loadDefaultsData()
        }
        
    }
    
    func loadFileData() -> [String:AnyObject]? {
        
        guard let data = fileManager?.loadData() else {
            return nil
        }
        return data
        
    }
    
    func loadDefaultsData() -> [String:AnyObject]? {
        
        guard let data = defaultsManager?.loadData() else {
            return nil
        }
        return data
    }
    
    /**
     Delete persisted data at ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Paramaters:
        - completion: Closure called upon completion of delete request, no error returned if successful.
     */
    func deleteData() -> Bool {
        
        if persistenceMode == .file {
            guard let fm = fileManager else {
                return false
            }
            return fm.deleteData()
        } else {
            guard let dm = defaultsManager else {
                return false
            }
            return dm.deleteData()
        }
    }

    
}


