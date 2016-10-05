//
//  TealiumDefaultsManagerTests.swift
//  tealium-swift
//
//  Created by Jason Koo on 11/3/16.
//  Copyright © 2016 tealium. All rights reserved.
//

import XCTest

class TealiumDefaultsManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit() {
        
        do {
            let defaultsManager = try TealiumDefaultsManager(account: "a", profile: "b", env: "c")
            XCTAssertTrue(defaultsManager.getStorageKey() == "a_b_c")

        } catch {
            XCTFail()
        }
        
    }
    
    func testAll() {
        
        do {
            let defaultsManager = try TealiumDefaultsManager(account: "a", profile: "b", env: "c")
            
            let testData = ["key":"value" as AnyObject] as [String:AnyObject]
            
            // Save
            defaultsManager.saveData(data: testData)
            
            // Load
            guard let savedData = defaultsManager.loadData() else {
                XCTFail("Could not retrieve saved data.")
                return
            }
            
            XCTAssertTrue(testData == savedData, "Data mismatch between testData: \(testData) and loadedSavedData: \(savedData)")
            
            // Persisted data file
            XCTAssertTrue(defaultsManager.persistedDataExists())
            
            let didDelete = defaultsManager.deleteData()
            
            XCTAssertTrue(didDelete)
            XCTAssertTrue(defaultsManager.loadData() == nil)
        
            
        } catch {
            XCTFail("DefaultsManager could not initialized.")
        }
        
    }
}
