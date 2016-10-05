//
//  tealiumConfig.swift
//  tealium-swift
//
//  Created by Jason Koo, Merritt Tidwell, Chad Hartman, Karen Tamayo, Chris Anderberg  on 8/31/16.
//  Copyright © 2016 tealium. All rights reserved.
//


// *****************************************
// MARK: Edit as Necessary
// *****************************************

let defaultTealiumConfig = TealiumConfig(account:"myAccount",
                                         profile:"myProfile",
                                         environment:"myEnvironment",
                                         optionalData:nil)


// *****************************************
// MARK: No need to edit below this line
// *****************************************

/*
 Configuration object for any Tealium instance.
 */
class TealiumConfig {
    
    let account : String
    let profile : String
    let environment : String
    var optionalData : [String:AnyObject]?
    
    init(account: String,
              profile: String,
              environment: String,
              optionalData: [String: AnyObject]?)  {
        
        self.account = account
        self.environment = environment
        self.profile = profile
        self.optionalData = optionalData
        
    }
    
    /**
         1.1 Support
     */
    @available(*, deprecated, message:"Access optional data property directly.")
    func getOptionalData(key: String) -> AnyObject? {
        return optionalData?[key]
    }
    
    /**
        1.1 Support
     */
    @available(*, deprecated, message:"Set optional data property directly.")
    func setOptionalData(key: String, value: AnyObject) {
        if optionalData == nil {
            optionalData = [String: AnyObject]()
        }
        optionalData?[key] = value
    }
}
