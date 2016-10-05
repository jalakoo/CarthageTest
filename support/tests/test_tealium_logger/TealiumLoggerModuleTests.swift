//
//  TealiumModule_LoggerTests.swift
//  tealium-swift
//
//  Created by Jason Koo on 11/1/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import XCTest

class TealiumLoggerModuleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMinimumProtocolsReturn() {
        
        let helper = test_tealium_helper()
        let module = TealiumLoggerModule(delegate: nil)
        let tuple = helper.modulesReturnsMinimumProtocols(module: module)
        XCTAssertTrue(tuple.success, "Not all protocols returned. Succeeding were protocols: \(tuple.protocolsSucceeding)")
        
    }
    
    func testEnableDisableProcess(){
        
        // Being a little lazy here.
        
        let loggerModule = TealiumLoggerModule(delegate: nil)
        loggerModule.enable(config: testTealiumConfig)
        
        XCTAssertTrue(loggerModule.logger != nil)
        
        let expectationSuccessfulProcess = self.expectation(description: "successfulLog")
        
        loggerModule.process(originatingModule: loggerModule, message: "testSuccess") { (success, error) in
            XCTAssertTrue(success, "Initial message processing call failed.")
            expectationSuccessfulProcess.fulfill()
        }
        
        loggerModule.disable()
        
        let expectationFailedProcess = self.expectation(description: "failedLog")
        loggerModule.process(originatingModule: loggerModule, message: "testFail") { (success, error) in
            XCTAssertFalse(success, "Disabled message processing succeededing when should have failed.")
            //XCTAssertTrue(error == TealiumLoggerModuleError.moduleDisabled, "Unexcped error returned: \(error)")
            expectationFailedProcess.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
        
    }

}
