//
//  TealiumIOManager.swift
//  tealium-swift
//
//  Created by Chad Hartman on 9/2/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

enum TealiumDefaultsManagerError: Error {
    case unknown
}
/**
    Internal persistent data handler.
 
 */
class TealiumDefaultsManager {
    
    private var storageKey : String
    
    /**
     Initializer.
     
     - Parameters:
         - account: Tealium account name.
         - profile: Tealium profile name.
         - env: Tealium environment name (dev, qa, prod).
         - completion: Closure executed with init is complete. Nil returned if successful.
     */
    init(account:String, profile:String, env: String) throws {
        
        storageKey = "\(account)_\(profile)_\(env)"
        
    }
    
    /**
     For checking existing storage key used for persisting files with.
     */
    func getStorageKey() -> String {
        return storageKey
    }
    
    /**
     Determine whether existing data is saved at ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Returns: true if the file exists.
     */
    func persistedDataExists() -> Bool {
        
        guard let _ = UserDefaults.standard.object(forKey: storageKey) as? [String:AnyObject] else {
            return false
        }
        
        return true
    
    }
    
    /**
     Persists a [String:AnyObject] instance to ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Parameters:
     - data: The desired data to persist, clobbers the previously saved file.
     */
    func saveData(data: [String:AnyObject]) {
        UserDefaults.standard.set(data, forKey: storageKey)
        UserDefaults.standard.synchronize()
    }
    
    /**
     Loads persisted data from ~/.tealium/swift/{account}_{profile}_{env}.data if it exists.
     
     - Returns: [String:AnyObject] data if exists, otherwise null if not present or corrupted.
     */
    func loadData() -> [String:AnyObject]? {
        
        guard let data = UserDefaults.standard.object(forKey: storageKey) as? [String:AnyObject] else {
            // No saved data
            return nil
        }
        
        return data
    
    }
    
    /**
     Delete persisted data from UserDefaults.
     
     */
    func deleteData() -> Bool {
        
        // False option not yet implemented
        if !persistedDataExists() {
            return true
        }
        
        UserDefaults.standard.removeObject(forKey: storageKey)
        UserDefaults.standard.synchronize()
        return true
    }

    
}


