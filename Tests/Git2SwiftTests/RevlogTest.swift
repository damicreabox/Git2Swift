//
//  RevlogTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 15/09/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import XCTest

import Foundation

@testable import Git2Swift

class RevlogTest: XCTestCase {
    
    static let name = "revTest"
    
    func testFileLog() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: RevlogTest.name + "FileLog")
            
            // Add files
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 1")
            _ = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 2")
            
            let fileRevLog1 = try FileHistoryIterator(repository: repository, path: "file2")
            XCTAssertNotNil(fileRevLog1.next())
            XCTAssertNil(fileRevLog1.next())
            
            let fileRevLog2 = try FileHistoryIterator(repository: repository, path: "file1")
            XCTAssertNotNil(fileRevLog2.next())
            XCTAssertNil(fileRevLog2.next())
            
            
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 2")
            let fileRevLog11 = try FileHistoryIterator(repository: repository, path: "file1")
            XCTAssertNotNil(fileRevLog11.next())
            XCTAssertNotNil(fileRevLog11.next())
            XCTAssertNil(fileRevLog11.next())
            
        } catch {
            XCTFail("\(error)")
        }
    }


}
