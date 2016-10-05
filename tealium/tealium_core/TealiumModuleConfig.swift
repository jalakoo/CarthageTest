//
//  TealiumModuleConfig.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/5/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

/**
    Configuration struct for TealiumModule subclasses.
 
 */
class TealiumModuleConfig {
    
    let name: String
    let priority : UInt
    var enabled : Bool
    
    init(name: String,
         priority: UInt,
         enabled: Bool) {
        
        self.name = name
        self.priority = priority
        self.enabled = enabled
        
    }
    
}

extension TealiumModuleConfig : Equatable {
    static func ==(lhs: TealiumModuleConfig, rhs: TealiumModuleConfig ) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        
        if lhs.priority != rhs.priority {
            return false
        }
        
        if lhs.enabled != rhs.enabled {
            return false
        }
        
        return true
    }
}
