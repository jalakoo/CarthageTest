//
//  TealiumModule.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/5/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

protocol TealiumModuleDelegate : class {
    
    func tealiumModuleDidEnable(module: TealiumModule)
    func tealiumModuleFailedToEnable(module: TealiumModule,
                                     error: Error?)
    func tealiumModuleDidDisable(module: TealiumModule)
    func tealiumModuleFailedToDisable(module: TealiumModule)
    func tealiumModuleDidTrack(module: TealiumModule,
                               data: [String:AnyObject],
                               info: [String:AnyObject]?,
                               completion:((_ successful:Bool, _ info:[String:AnyObject]?, _ error: Error?) -> Void)?)
    func tealiumModuleFailedToTrack(module: TealiumModule,
                                    data: [String:AnyObject],
                                    info: [String:AnyObject]?,
                                    error: Error?,
                                    completion: ((_ successful:Bool, _ info:[String:AnyObject]?,_ error: Error?) -> Void)?)
    func tealiumModuleRequestsTrackCall(module: TealiumModule,
                                        data: [String:AnyObject],
                                        info: [String:AnyObject]?)
    func tealiumModuleEncounteredError(module: TealiumModule,
                                       error: Error)
    /**
     Used to pass messages between modules, such as debug logging.
     - Parameters:
     
        - module: The module requesting a message be sent to other modules.
        - message: The message string to deliver.
     */
    func tealiumModuleRequestsProcessing(module: TealiumModule,
                                         message: String)
    
    /**
     Called by all modules after receiving a message from another module via
        the modulesManager.
     
     -Parameters:
        - module: The module that just finished processing.
        - originatingModule: The original module that sent the message.
        - message: The message payload, possibly modfied by the current module.
     */
    func tealiumModuleDidProcess(module: TealiumModule,
                                 originatingModule: TealiumModule,
                                 message: String)

}

/**
    Base class for all Tealium feature modules.
 */
class TealiumModule {
    
    weak var delegate : TealiumModuleDelegate?
    
    required init(delegate: TealiumModuleDelegate?){
        self.delegate = delegate
    }
    
    // MARK:
    // MARK: OVERRIDABLE FUNCTIONS
    func moduleConfig() -> TealiumModuleConfig {
        return TealiumModuleConfig(name: "default",
                                   priority: 0,
                                   enabled: false)
    }

    // Should only be called by the ModulesManager.
    func update(config: TealiumConfig) {
        
        if moduleConfig().enabled == false {
            disable()
            return
        }
        
        enable(config: config)
    }
    
    // MARK:
    // MARK: PUBLIC OVERRIDES
    // These methods should be overwritten by module subclasses.
    
    /**
     Start the module.
     
     - Parameters:
        - config: The TealiumConfig object used for the instance this module is associated with.
     */
    func enable(config: TealiumConfig) {
        
        didFinishEnable(config: config)
        
    }
    
    /**
     Stop the module for futher running.
     */
    func disable() {
        
        didFinishDisable()

    }
    
    /**
     Process a track call request (deliver/edit/suppress/save/etc.). didFinishTrack MUST be called at end.
     */
    func track(data: [String: AnyObject],
               info: [String: AnyObject]?,
               completion: ((_ successful:Bool, _ info:[String:AnyObject]?, _ error: Error?) -> Void)?) {
    
    
        didFinishTrack(data: data,
                       info: info,
                       completion: completion)

    }
    
    /**
     Convenience for process(module: originatingModule: message: completion:)
     
     - Parameters:
        - module:
        - originatingModule:
        - message:
     */
    func process(originatingModule: TealiumModule, message: String) {
        
        process(originatingModule: originatingModule, message: message, completion: nil)

    }
 
    /**
     For interprocess communications, like the logger or debug modules.
     
     - Parameters:
         - module: Current module process (this cl
         - originatingModule: Original TealiumModule subclass that sent message.
         - message: String message to pass along to other modules.
         - completion: Optional completion block handler.
     */
    func process(originatingModule: TealiumModule,
                 message: String,
                 completion: ((_ success: Bool, _ error: Error?)->Void)?) {
        
        didFinishProcess(originatingModule: originatingModule,
                         message: message)
        
    }
    
    // MARK:
    // MARK: SUBCLASS CONVENIENCE METHODS
    
    func didFinishEnable(config:TealiumConfig) {
        delegate?.tealiumModuleDidEnable(module: self)
    }
    
    func didFailToEnable(config:TealiumConfig, error: Error)
    {
        delegate?.tealiumModuleFailedToEnable(module: self, error: error)
    }
    
    func didFinishDisable() {
        delegate?.tealiumModuleDidDisable(module: self)
    }
    
    func didFailToDisable(error:Error){
        delegate?.tealiumModuleFailedToDisable(module: self)
    }
    
    func didFinishTrack(data: [String:AnyObject],
                        info: [String:AnyObject]?,
                        completion: ((_ successful:Bool, _ info:[String:AnyObject]?, _ error: Error?)-> Void)?){
        
        delegate?.tealiumModuleDidTrack(module: self,
                                        data: data,
                                        info: info,
                                        completion: completion)
        
    }
    
    func didFailToTrack(data: [String:AnyObject],
                        info: [String:AnyObject]?,
                        error: Error,
                        completion: ((_ successful:Bool, _ info:[String:AnyObject]?, _ error: Error?)-> Void)?){
        
        delegate?.tealiumModuleFailedToTrack(module: self,
                                             data: data,
                                             info: info,
                                             error: error,
                                             completion: completion)
        
    }
    
    func didFinishProcess(originatingModule: TealiumModule, message: String){
        delegate?.tealiumModuleDidProcess(module: self,
                                          originatingModule: originatingModule,
                                          message: message)
    }
}

extension TealiumModule : Equatable {
    
    static func == (lhs: TealiumModule, rhs: TealiumModule ) -> Bool {
        return lhs.moduleConfig() == rhs.moduleConfig()
    }
    
}
