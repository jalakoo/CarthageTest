//
//  TealiumModulesManager.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/5/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation
import ObjectiveC

enum TealiumModulesManagerError : Error {
    
    case isDisabled
    case noModules
    case noModuleConfigs
    
}
/**
    Coordinates optional modules with primary Tealium class.
 
 */
class TealiumModulesManager : NSObject {
    
    var config : TealiumConfig
    var modules = [TealiumModule]()
    var moduleConfigs = [TealiumModuleConfig]()
    var isEnabled = true

    init(config:TealiumConfig) {
        
        self.config = config
        
    }
    
    // MARK:
    // MARK: PUBLIC
    func updateAll() {
        
        if self.modules.isEmpty {
            let newModules = getClassesOfType(c: TealiumModule.self)
            
            // Create instances of each module
            for module in newModules {
                addModule(klass: module)
            }
            
        }
        
        // Enable first module to start chain enabling
        isEnabled = true
        self.modules.prioritized()[0].update(config:self.config)
        
    }
    
    func disableAll() {
        isEnabled = false
        self.modules.prioritized()[0].disable()
    }
    
    /**
        Convenience track method that converts title to an standardized variable.
     */
    func track(type: TealiumTrackType,
               title: String,
               data: [String: AnyObject]?,
               info: [String: AnyObject]?,
               completion: ((_ successful:Bool, _ info: [String:AnyObject]?, _ error: Error?) -> Void)?) {
        
        if isEnabled == false {
            completion?(false, nil, TealiumModulesManagerError.isDisabled)
            return
        }
        
        // Convert convience title to dictionary payload
        var dataDictionary: [String : AnyObject] = [TealiumKey.event: title as AnyObject,
                                                    TealiumKey.eventName: title as AnyObject,
                                                    TealiumKey.eventType: type.description() as AnyObject]
        
        if let additionalData = data {
            dataDictionary += additionalData
        }
        
        track(data: dataDictionary,
              info: info,
              completion: completion)
        
    }
    
    func getModule(forName: String) -> TealiumModule? {
        
        return modules.first(where: {$0.moduleConfig().name == forName})

    }

    // MARK:
    // MARK: INTERNAL AUTO MODULE DETECTION
    func getClassesOfType(c: AnyClass) -> [AnyClass] {
        let classes = getClassList()
        var ret = [AnyClass]()
        
        for cls in classes {
            if (class_getSuperclass(cls) == c) {
                ret.append(cls)
            }
        }
        return ret
    }
    
    func getClassList() -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
        let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)] {
                classes.append(currentClass)
            }
        }
        
        allClasses.deallocate(capacity: Int(expectedClassCount))
        
        return classes
    }
    
    func addModule(klass: AnyClass){
    
        guard let type = klass as? TealiumModule.Type else {
            // Type does not exist - skip
            return
        }
        
        let module = type.init(delegate: self)
        
        modules.append(module)
        
    }
    
    // MARK:
    // MARK: INTERNAL TRACK HANDLING
    func track(data: [String:AnyObject],
               info: [String:AnyObject]?,
               completion: ((_ successful:Bool, _ info:[String:AnyObject]?, _ error: Error?) -> Void)?){
        
        guard let firstModule = modules.first else {
            completion?(false, nil, TealiumModulesManagerError.noModules)
            return
        }
        
        firstModule.track(data: data,
                          info: nil,
                          completion: completion)
        
    }

}

// MARK:
// MARK: TEALIUM MODULE DELEGATE
extension TealiumModulesManager : TealiumModuleDelegate {
    
    func tealiumModuleDidEnable(module: TealiumModule) {
        
        modules.first?.process(originatingModule: module, message: "ENABLED.")
        
        // TODO: Handle improperly created modules with no init override?
        
        modules.next(after: module)?.update(config: self.config)
        
    }
    
    func tealiumModuleFailedToEnable(module: TealiumModule, error: Error?) {
        
        modules.first?.process(originatingModule: module, message: "FAILED to enable: \(error?.localizedDescription)")
        
        modules.next(after: module)?.update(config: self.config)
        
    }
    
    func tealiumModuleDidDisable(module: TealiumModule) {

        modules.first?.process(originatingModule: module, message: "DISABLED.")

        modules.next(after: module)?.update(config:self.config)

    }
    
    func tealiumModuleFailedToDisable(module: TealiumModule) {
        
        modules.next(after: module)?.update(config:self.config)

    }
    
    func tealiumModuleDidTrack(module: TealiumModule,
                               data: [String : AnyObject],
                               info: [String: AnyObject]?,
                               completion: ((Bool, [String:AnyObject]?, Error?) -> Void)?) {
     
        modules.next(after: module)?.track(data: data,
                                           info: info,
                                           completion: completion)
        
    }
    
    func tealiumModuleFailedToTrack(module: TealiumModule,
                                    data: [String : AnyObject],
                                    info: [String : AnyObject]?,
                                    error: Error?,
                                    completion: ((Bool, [String:AnyObject]?, Error?) -> Void)?) {
        
        // TODO: handle error
        
        modules.first?.process(originatingModule: module, message: "FAILED to track call.")

        // Permit other modules to attempt track? -- OR run
        modules.next(after: module)?.track(data: data,
                                           info: info,
                                           completion: completion)
        
    }
    
    func tealiumModuleRequestsTrackCall(module: TealiumModule,
                                        data: [String : AnyObject],
                                        info: [String : AnyObject]?) {
        
        if isEnabled == false {
            return
        }
        
        self.track(data: data,
                   info: info,
                   completion: nil)
        
    }
    
    func tealiumModuleEncounteredError(module: TealiumModule, error: Error) {
        
        // TODO: Error handling?
        modules.first?.process(originatingModule:module, message: "\(module.moduleConfig().name) detected ERROR: \(error).")

    }
    
    func tealiumModuleRequestsProcessing(module: TealiumModule, message: String) {
        
        modules.first?.process(originatingModule: module, message: message)
        
    }
    
    func tealiumModuleDidProcess(module: TealiumModule, originatingModule:TealiumModule, message: String) {
        
        let nextModule = modules.next(after:module)
        
        nextModule?.process(originatingModule: originatingModule, message: message)
        
    }
}

// MARK: 
// MARK: MODULEMANAGER EXTENSIONS
extension Array where Element : TealiumModule {
    
    /**
     Convenience for sorting Arrays of TealiumModules by priority number: Lower numbers going first.
     */
    func prioritized() -> [TealiumModule] {
        return self.sorted{
            $0.moduleConfig().priority < $1.moduleConfig().priority
        }
        
    }
    
}

extension Array where Element: Equatable {

    /**
     Convenience for getting the next object in a given array.
     */
    func next(after:Element) -> Element? {
        
        for i in 0..<self.count {
            let object = self[i]
            if object == after {
                
                if i + 1 < self.count {
                    return self[i+1]
                }
            }
        }
        
        return nil
        
    }
    
}
