//
//  CommitTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 12/08/2016.
//
//

import XCTest

@testable import Git2Swift

class CommitTest: XCTestCase {
    
    static let repoName = "commitTestRepo"
    
    func testReference() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: CommitTest.repoName)
            
            // Find HEAD
            let head = try repository.referenceLookup(name: "HEAD")
            XCTAssertEqual("HEAD", head.name)
            
            // Add files
            _ = try RepositoryHelper.addFile(repository: repository,
                                             name: "Test title\n\nfile1",
                                             data: "Data content 1",
                                             signature: Signature(name: "moi", email: "monemail@test.fr")
            )
            
            let target = try head.targetReference()
            let commit = try target.targetCommit()
            
            XCTAssertEqual("Test title", commit.summary)
            XCTAssertEqual("file1", commit.body)
            XCTAssertEqual("moi", commit.author.name)
            XCTAssertEqual("moi", commit.committer.name)
            
            //print("Date \(commit.date)")
            //print("TimeZone \(commit.timeZone)")
            
        } catch {
            XCTFail("\(error)")
        }
    }

}
