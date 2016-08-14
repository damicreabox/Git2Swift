//
//  IndexTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 01/08/2016.
//
//

import XCTest

@testable import Git2Swift

class IndexTest: XCTestCase {
    
    static let repoName = "indexTest"
    
    func testReference() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: IndexTest.repoName)
            
            // Create files
            let readmeUrl = try DirectoryManager.createFile(at: repository.url, name: "README.md")
            let fileOneUrl = try DirectoryManager.createFile(at: repository.url, name: "fileOne")
            
            // Create index
            let index1 = try repository.head().index()
            try index1.reload()
            
            // Add items
            try index1.addItem(at: readmeUrl)
            try index1.addItem(at: fileOneUrl)
            
            // Save
            try index1.save()
            
            // Commit
            let commit1 = try index1.createCommit(msg: "Add readme and file one", signature: try RepositoryHelper.systemSignature())
            
            XCTAssertNotNil(commit1.oid.sha())
            
            // Create index
            let index2 = try repository.head().index()
            
            // Remove file one
            try index2.removeItem(at: fileOneUrl)
            
            // Save
            try index2.save()
            
            // Commit
            let commit2 = try index2.createCommit(msg: "Remove file one", signature: try RepositoryHelper.systemSignature())
            
            XCTAssertNotNil(commit2.oid.sha())
            
            try index2.clear()
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
