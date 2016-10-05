//
//  TealiumModulesManagerTests.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/11/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import XCTest

//let mmtAccountInfo : [String:String] = [
//    TealiumKey.account: "tealiummobile",
//    TealiumKey.profile: "demo",
//    TealiumKey.environment: "dev",
//]

class TealiumTestModule : TealiumModule {
    
    override func enable(config: TealiumConfig) {
        super.enable(config: config)
    }
}

class TealiumModulesManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testInitPerformance() {
        
        let iterations = 1000
        
        self.measure {
            
            for _ in 0..<iterations {
                
                let _ = TealiumModulesManager(config: defaultTealiumConfig)
            }
            
        }
        
    }
    
    func testPublicTrackWithNoModules() {
        
        let manager = TealiumModulesManager(config: testTealiumConfig)
        
        let expectation = self.expectation(description: "testPublicTrack")
        
        manager.track(data: [:],
                      info: nil) { (success, info, error) in
                        
                        guard let error = error else {
                            XCTFail("Error should have returned")
                            return
                        }
                        
                        XCTAssertFalse(success, "Track did not fail as expected. Error: \(error)")
                        
                        expectation.fulfill()
                        
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
    func testPublicTrackWithDefaultModules() {
        
        let manager = TealiumModulesManager(config: testTealiumConfig)
        manager.updateAll()
        
        let expectation = self.expectation(description: "testPublicTrack")
        
        manager.track(data: [:],
                      info: nil) { (success, info, error) in
                        
                        XCTAssertTrue(success, "Track was not successful. Error: \(error)")
                        
                        expectation.fulfill()
                        
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
//    func testConformsToModulesProtocol() {
//        
//        XCTAssertTrue(TealiumModulesManager.conforms(to: TealiumModuleDelegate.self))
//
//    }
    
//    func moduleConfigs(number: Int) -> [TealiumModuleConfig] {
//        var configs = [TealiumModuleConfig]()
//        for i in (0..<number).reversed() {
//            let moduleConfig = TealiumModuleConfig(name: "\(i)", className: "TealiumTestModule", priority: UInt(i), enabled: true)
//            configs.append(moduleConfig)
//        }
//        
//        return configs
//    }
//    
//    func config(forNumberOfModules: Int) -> TealiumConfig{
//        let moduleConfigs = self.moduleConfigs(number: forNumberOfModules)
//        let config = TealiumConfig(account: "a", profile: "b", environment: "c", optionalData: nil)
//        return config
////        return [TealiumKey.accountInfo : accountInfo,
////                TealiumModuleConfigKey.all : moduleConfigs]
//    }
    
    func testUpdateAllPeformance() {
        
        let modules = 100
//        let config = self.config(forNumberOfModules: modules)
        
        self.measure {
            
            let mm = TealiumModulesManager(config: defaultTealiumConfig)
            mm.updateAll()
            
        }
        
    }
    
//    func testPrioritizeModuleConfigs() {
//        
//        let modules = 10
//        let config = self.config(forNumberOfModules: modules)
//        
//        let moduleConfigs = config.moduleConfigs
//        
//        // Test to make sure we're not already sorted
//        // This only works as we know we created the test array in reverse order
//        var prior = UInt(moduleConfigs.count+1)
//        for x in 0..<moduleConfigs.count {
//            let config = moduleConfigs[x]
//            XCTAssertFalse(prior < config.priority, "prior:\(prior) - moduleConfig.priority:\(config.priority)")
//            prior = config.priority
//        }
//    
//        
//        let prioritizedConfigs = moduleConfigs.prioritized()
//        
//        for i in 0..<prioritizedConfigs.count {
//            
//            let config = prioritizedConfigs[i]
//            
//            XCTAssertTrue(config.priority == UInt(i), "Config not in prioritized order:\(prioritizedConfigs)")
//            
//        }
//        
//        
//    }
    
//    func testModuleConfigForName() {
//        
//    }
//
//    func testModuleConfigAfter() {
//        
//    }
//    
//    func testModuleForConfig() {
//        
//    }
//    
//    func testUpdateModule() {
//        
//    }
//    
//    func testModuleAfterModule() {
//        
//    }
    
    func testStringToBool() {
        
        // Not entirely necessary as long as we're using NSString.boolValue
        // ...but just in case it gets swapped out
        
        let stringTrue = "true"
        let stringYes = "yes"
        let stringFalse = "false"
        let stringFALSE = "FALSE"
        let stringNo = "no"
        let stringOtherTrue = "35a"
        let stringOtherFalse = "xyz"
        
        XCTAssertTrue(stringTrue.boolValue)
        XCTAssertTrue(stringYes.boolValue)
        XCTAssertFalse(stringFalse.boolValue)
        XCTAssertFalse(stringFALSE.boolValue)
        XCTAssertFalse(stringNo.boolValue)
        XCTAssertTrue(stringOtherTrue.boolValue, "String other converted to \(stringOtherTrue.boolValue)")
        XCTAssertFalse(stringOtherFalse.boolValue, "String other converted to \(stringOtherFalse.boolValue)")
    }

}
