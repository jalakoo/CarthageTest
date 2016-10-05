//
//  test_tealium_helper.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/25/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import Foundation

enum TealiumTestKey {

    static let stringKey = "keyString"
    static let stringArrayKey = "keyArray"
}


enum TealiumTestValue {
    static let account = "testAccount"
    static let profile = "testProfile"
    static let environment = "testEnviroment"
    static let eventType = TealiumTrackType.activity.description()
    static let stringValue = "value"
    static let title = "testTitle"
    static let sessionId = "1234567890124"
    static let visitorID = "someVisitorId"
    static let random = "someRandomNumber"
}

let testStringArrayValue = ["value1", "value2"]
let testOptionalData = [TealiumTestKey.stringKey: TealiumTestValue.stringValue as AnyObject,
                        TealiumTestKey.stringArrayKey: testStringArrayValue as AnyObject] as [String : AnyObject]
let testTealiumConfig = TealiumConfig(account:TealiumTestValue.account,
                                      profile:TealiumTestValue.profile,
                                      environment:TealiumTestValue.environment,
                                      optionalData:testOptionalData as [String : AnyObject])

let testDataDictionary : [String:AnyObject]  =
    [
        TealiumKey.account : TealiumTestValue.account as AnyObject,
        TealiumKey.profile : TealiumTestValue.profile as AnyObject,
        TealiumKey.environment : TealiumTestValue.environment as AnyObject,
        TealiumKey.event : TealiumTestValue.title as AnyObject,
        TealiumKey.eventName : TealiumTestValue.title as AnyObject,
        TealiumKey.eventType :  TealiumTestValue.eventType as AnyObject,
        TealiumKey.libraryName : TealiumValue.libraryName as AnyObject,
        TealiumKey.libraryVersion : TealiumValue.libraryVersion as AnyObject,
        TealiumKey.sessionId : TealiumTestValue.sessionId as AnyObject,
        TealiumKey.visitorId :TealiumTestValue.visitorID as AnyObject,
        TealiumKey.legacyVid : TealiumTestValue.visitorID as AnyObject,
        TealiumKey.random : TealiumTestValue.random as AnyObject
    ]

class test_tealium_helper {
    
    var callBack : ((TealiumModule, String)->Void)?
    
    // Any subclass of the TealiumModule must eventually trigger it's protocol
    //  for the ModulesManager to work properly.
    
    func didReceiveCallBack(completion:((_ module: TealiumModule, _ protocolName: String)->Void)?){
        callBack = completion
    }
    
    
    func modulesReturnsMinimumProtocols(module: TealiumModule) -> (success: Bool, protocolsSucceeding: [String]){
        
        var succeedingProtocols = Set<String>()
        
        didReceiveCallBack { (module, protocolName) in
            succeedingProtocols.insert(protocolName)
        }
        
        module.delegate = self
        
        // The 4 standard calls
        module.enable(config: testTealiumConfig)
        module.disable()
        module.track(data: [:],
                     info: nil,
                     completion: nil)
        module.process(originatingModule: module,
                       message: "")
        
        
        let successfulProtocolAsArray = Array(succeedingProtocols)
        return (succeedingProtocols.count >= 4, successfulProtocolAsArray)
        
    }
    
}

extension test_tealium_helper : TealiumModuleDelegate {
 
    func tealiumModuleDidEnable(module: TealiumModule) {
        callBack?(module, "tealiumModuleDidEnable")
    }
    
    func tealiumModuleDidDisable(module: TealiumModule) {
        callBack?(module, "tealiumModuleDidDisable")

    }
    
    func tealiumModuleFailedToEnable(module: TealiumModule, error: Error?) {
        callBack?(module, "tealiumModuleFailedToEnable")

    }
    
    func tealiumModuleFailedToDisable(module: TealiumModule) {
        callBack?(module, "tealiumModuleFailedToDisable")

    }
    
    func tealiumModuleEncounteredError(module: TealiumModule, error: Error) {
        callBack?(module, "tealiumModuleEncounteredError")

    }
    
    func tealiumModuleRequestsProcessing(module: TealiumModule, message: String) {
        callBack?(module, "tealiumModuleRequestsProcessing")

    }
    
    func tealiumModuleDidProcess(module: TealiumModule, originatingModule: TealiumModule, message: String) {
        callBack?(module, "tealiumModuleDidProcess")

    }
    
    func tealiumModuleRequestsTrackCall(module: TealiumModule, data: [String : AnyObject], info: [String : AnyObject]?) {
        callBack?(module, "tealiumModuleRequestsTrackCall")

    }
    
    func tealiumModuleDidTrack(module: TealiumModule, data: [String : AnyObject], info: [String : AnyObject]?, completion: ((Bool, [String : AnyObject]?, Error?) -> Void)?) {
        callBack?(module, "tealiumModuleDidTrack")

    }
    
    func tealiumModuleFailedToTrack(module: TealiumModule, data: [String : AnyObject], info: [String : AnyObject]?, error: Error?, completion: ((Bool, [String : AnyObject]?, Error?) -> Void)?) {
        callBack?(module, "tealiumModuleFailedToTrack")

    }
}
