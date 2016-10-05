//
//  TealiumCollectModule.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/7/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

enum TealiumCollectModuleKey {
    static let name = "collect"
}

extension Tealium {
    
    /**
     Deprecated - use the track(title: String, data: [String:AnyObject]?, completion:((_ success: Bool, _ error: Error?)->Void) function instead. Convience method to track event with optional data.
     
     - Parameters:
         - Event Title: Required title of event )
         - Data: Optional dictionary for additional data sources to pass with call
         - Completion: Optional callback
     */
//    @available(*, deprecated, message: "No longer supported. See the new track(title: String, data: [String:AnyObject]?, completion:((success, error)->Void) function.")
//    func track(title: String,
//               data: [String: AnyObject]?,
//               completion: ((_ successful:Bool, _ encodedURLString: String, _ error: NSError?) -> Void)?) {
//        
//    }
    
    /**
     Deprecated - use the track(title: String, data: [String:AnyObject]?, completion:((_ success: Bool, _ error: Error?)->Void) function instead. Convience method to track event with optional data.
     
     - Parameters:
        - encodedURLString: Encoded string that will be used for the end point for the request
        - Completion: Optional callback
     */
    @available(*, deprecated, message: "No longer supported. Will be removed next version.")
    func track(encodedURLString: String,
               completion: ((_ successful: Bool, _ encodedURLString: String, _ error: NSError?)->Void)?){
        
        // TODO: complete?
        collect()?.send(finalStringWithParams: encodedURLString,
                        completion: { (success, info,  error) in
                            
                // Make new call but return empty responses for encodedURLString and error
                
                var encodedURLString = ""
                if let encodedURLStringRaw = info?[TealiumCollectKey.encodedURLString] as? String {
                    encodedURLString = encodedURLStringRaw
                }
                            
                // TODO: convert error to NSError
                            
                completion?(success, encodedURLString, nil)
                            
        }) 
    }
    
    fileprivate func collect() -> TealiumCollect? {
        
        guard let collectModule = modulesManager.getModule(forName: TealiumCollectModuleKey.name) as? TealiumCollectModule else {
            return nil
        }
        
        return collectModule.collect
        
    }
    
}

extension TealiumModulesManager {
    
    /**
     Deprecating.
     */
    @available(*, deprecated, message: "No longer supported. See the new track(title: String, data: [String:AnyObject]?, completion:((success, error)->Void) function.")
    func trackCollect(_ title: String,
               data: [String: AnyObject]?,
               completion: ((_ successful:Bool, _ encodedURLString: String, _ error: NSError?) -> Void)?) {
        
        // TODO:
        
    }
    
    /**
     Deprecating.
     */
    @available(*, deprecated, message: "No longer supported. Will be removed next version.")
    func track(encodedURLString: String,
               completion: ((_ successful: Bool, _ encodedURLString: String, _ error: NSError?)->Void)?){
        
        // TODO:
        
    }
    
}

class TealiumCollectModule : TealiumModule {
    
    var collect : TealiumCollect?

    override func moduleConfig() -> TealiumModuleConfig {
        return TealiumModuleConfig(name: TealiumCollectModuleKey.name,
                                   priority: 1000,
                                   enabled: true)
    }
    
    override func enable(config:TealiumConfig) {
        
        // Collect dispatch service
        var urlString : String
        if let collectURLString = config.optionalData?[TealiumKey.overrideCollectUrl] as? String{
            urlString = collectURLString
        } else {
            urlString = TealiumCollect.defaultBaseURLString()
        }
        self.collect = TealiumCollect(baseURL: urlString)
        
        didFinishEnable(config: config)
        
    }
    
    override func disable() {
        
        self.collect = nil
        
        didFinishDisable()

    }

    override func track(data: [String : AnyObject],
                        info: [String : AnyObject]?,
                        completion: ((Bool, [String:AnyObject]?, Error?) -> Void)?) {
        
        collect?.dispatch(data: data, completion: { (success, info, error) in
            
            self.delegate?.tealiumModuleRequestsProcessing(module: self, message: "Successfully delivered: \(success)")
            completion?(success, info, error)
        })
        
        // Completion handed off to collect dispatch service - forward track to any subsequent modules for any remaining processing.
        
        didFinishTrack(data: data,
                       info: info,
                       completion: completion)
        
    }

}
