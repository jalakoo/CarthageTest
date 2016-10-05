//
//  TealiumModuleTests.swift
//  tealium-swift
//
//  Created by Jason Koo on 10/11/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import XCTest
import ObjectiveC

class TealiumModuleTests: XCTestCase {

    
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
            
            for _ in 0...iterations {
                
                let _ = TealiumModule(delegate: nil)
            }
            
        }
        
    }
    
    func testMinimumProtocolsReturn() {
        
        let helper = test_tealium_helper()
        let module = TealiumModule(delegate: nil)
        let tuple = helper.modulesReturnsMinimumProtocols(module: module)
        XCTAssertTrue(tuple.success, "Not all protocols returned. Succeeding were protocols: \(tuple.protocolsSucceeding)")
        
    }

//    func getClassesImplementingProtocol(p: Protocol) -> [AnyClass] {
//        let classes = getClassList()
//        var ret = [AnyClass]()
//        
//        for cls in classes {
//            if class_conformsToProtocol(cls, p) {
//                ret.append(cls)
//            }
//        }
//        return ret
//    }
    
//    func respondsToAllProtocols(module:TealiumModule)-> Bool {
//        
//        
//        
//    }
}
