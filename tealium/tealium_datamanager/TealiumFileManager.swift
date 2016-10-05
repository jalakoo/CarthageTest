//
//  TealiumIOManager.swift
//  tealium-swift
//
//  Created by Chad Hartman on 9/2/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

enum TealiumFileManagerError: Error {
    case unknown
    case cannotWriteToDisk
}
/**
    Internal persistent data handler for
 
 */
class TealiumFileManager {
    
    private let persistenceFilePath: String
    
    /**
     Initializer.
     
     - Parameters:
         - account: Tealium account name.
         - profile: Tealium profile name.
         - env: Tealium environment name (dev, qa, prod).
         - completion: Closure executed with init is complete. Nil returned if successful.
     */
    init(account:String, profile:String, env: String) throws {
        
        let parentDir = "\(NSHomeDirectory())/.tealium/swift/"
        do {
            try FileManager.default.createDirectory(atPath: parentDir, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            
            if error.code == 1 {
                throw TealiumFileManagerError.cannotWriteToDisk
            } else {
                throw TealiumFileManagerError.unknown
            }
        }
        
        persistenceFilePath = "\(parentDir)/\(account)_\(profile)_\(env).data"
    }
    
    /**
     Determine whether existing data is saved at ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Returns: true if the file exists.
     */
    func persistedDataExists() -> Bool {
        return FileManager.default.fileExists(atPath: persistenceFilePath)
    }
    
    /**
     Persists a [String:AnyObject] instance to ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Parameters:
     - data: The desired data to persist, clobbers the previously saved file.
     */
    func saveData(_ data:[String:AnyObject]) {
        NSKeyedArchiver.archiveRootObject(data, toFile: persistenceFilePath)
    }
    
    /**
     Loads persisted data from ~/.tealium/swift/{account}_{profile}_{env}.data if it exists.
     
     - Returns: [String:AnyObject] data if exists, otherwise null if not present or corrupted.
     */
    func loadData() -> [String:AnyObject]? {
        if persistedDataExists() {
            return NSKeyedUnarchiver.unarchiveObject(withFile: persistenceFilePath) as? [String:AnyObject]
        }
        
        return nil
    }
    
    /**
     Delete persisted data at ~/.tealium/swift/{account}_{profile}_{env}.data.
     
     - Paramaters:
        - completion: Closure called upon completion of delete request, no error returned if successful.
     */
    func deleteData() -> Bool {
        
        if !persistedDataExists() {
            return true
        }
        
        do {
            try FileManager.default.removeItem(atPath: persistenceFilePath)
        
        }
        catch _ as NSError {
            // TODO:
            return false
        }
        
        return true
    }

    
}


