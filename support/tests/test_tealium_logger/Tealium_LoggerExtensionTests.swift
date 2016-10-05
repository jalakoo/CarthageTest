//
//  Tealium_LoggerExtensionTests.swift
//  tealium-swift
//
//  Created by Jason Koo on 11/3/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import XCTest

class Tealium_LoggerExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetGetLogLevelExtension() {
        
        let tealium = Tealium(config: testTealiumConfig)
        
        let logger = TealiumLoggerModule(delegate: nil)
        
        tealium?.modulesManager.modules.append(logger)
        
        let logLevel = tealium?.getLogLevel()
        
        // Check default setting
        XCTAssertTrue(logLevel == LogLevel.verbose, "Unexpected log level returned: \(logLevel)")
        
        // Check set
        tealium?.setLogLevel(logLevel: LogLevel.errors)
        
        let newLoglevel = tealium?.getLogLevel()
        
        XCTAssertTrue(newLoglevel == LogLevel.errors, "Unexpected log leve returned: \(logLevel)")
        
    }

}
