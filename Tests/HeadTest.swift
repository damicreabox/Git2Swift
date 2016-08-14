//
//  HeadTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 11/08/2016.
//
//

import XCTest

class HeadTest: XCTestCase {
    
    static let name = "headTest"
    
    func testResetHead() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: HeadTest.name + "Reset")
            
            XCTAssertTrue(repository.statuses.workingDirectoryClean)
            
            // Add files
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 1")
            
            XCTAssertTrue(repository.statuses.workingDirectoryClean)
            
            // Create file
            let url1 = try DirectoryManager.createFile(at: repository.url, name: "file1")
            
            // Check file exists
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            
            XCTAssertFalse(repository.statuses.workingDirectoryClean)
            
            let statusesIterator = try repository.statuses.all()
            XCTAssertNotNil(statusesIterator.next())
            XCTAssertNil(statusesIterator.next())
            
            // Reset head
            try repository.head().reset(type: .hard)
            
            XCTAssertTrue(repository.statuses.workingDirectoryClean)
            
        } catch {
            XCTFail("\(error)")
        }
    }

}
