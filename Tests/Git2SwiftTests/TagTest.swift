//
//  TagTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 12/08/2016.
//
//

import XCTest

import Foundation

@testable import Git2Swift

class TagTest: XCTestCase {
    
    static let name = "tagTest"
    
    func testAll() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: BranchTest.name + "All")
            
            // Get tags
            let tags = repository.tags
            
            // Add file 1
            let url1 = try RepositoryHelper.addFile(repository: repository, name: "file1")
            let commit1 = try  repository.head().targetCommit()
            
            // Create tag 1
            let tag1 = try tags.create(name: "tag1")
            
            // Find current commit
            let url2 = try RepositoryHelper.addFile(repository: repository, name: "file2")
            let commit2 = try  repository.head().targetCommit()
            
            let tag2 = try tags.create(name: "tag2")
            
            // Find current commit
            let url3 = try RepositoryHelper.addFile(repository: repository, name: "file3")
            let commit3 = try  repository.head().targetCommit()
            
            let tag3 = try tags.create(name: "tag3")
            
            XCTAssertEqual("refs/tags/tag1", tag1.name)
            XCTAssertEqual("refs/tags/tag2", tag2.name)
            XCTAssertEqual("refs/tags/tag3", tag3.name)
            
            XCTAssertEqual("tag1", tag1.shortName)
            XCTAssertEqual("tag2", tag2.shortName)
            XCTAssertEqual("tag3", tag3.shortName)
            
            XCTAssertEqual(commit1.oid.sha(), tag1.oid.sha())
            XCTAssertEqual(commit2.oid.sha(), tag2.oid.sha())
            XCTAssertEqual(commit3.oid.sha(), tag3.oid.sha())
            
            // Iterator
            let iterator = try tags.all()
            
            let tagIt1 = iterator.next()
            XCTAssertNotNil(tagIt1)
            XCTAssertEqual("refs/tags/tag1", tagIt1!.name)
            
            let tagIt2 = iterator.next()
            XCTAssertNotNil(tagIt2)
            XCTAssertEqual("refs/tags/tag2", tagIt2!.name)
            
            let tagIt3 = iterator.next()
            XCTAssertNotNil(tagIt3)
            XCTAssertEqual("refs/tags/tag3", tagIt3!.name)
            
            let tagItEnd = iterator.next()
            XCTAssertNil(tagItEnd)
            
            // Delete tag2
            try tags.remove(name: "tag2")
            
            let names = tags.names()
            XCTAssertEqual(2, names.count)
            XCTAssertEqual("tag1", names[0])
            XCTAssertEqual("tag3", names[1])
            
            // Find tag
            let tagsWith1 = try tags.find(withPattern: "tag*")
            XCTAssertNotNil(tagsWith1.next())
            XCTAssertNotNil(tagsWith1.next())
            XCTAssertNil(tagsWith1.next())
            
            // Find tag
            let tagsWith2 = try tags.find(withPattern: "*1")
            XCTAssertNotNil(tagsWith2.next())
            XCTAssertNil(tagsWith2.next())
            
            // Creating again tag3
            XCTAssertThrowsError(try tags.create(name: "tag3"))
            
            // Create again tag3 with force flag
            let tag1Bis = try tags.create(name: "tag3", force: true)
            
            XCTAssertEqual(commit3.oid.sha(), tag1Bis.oid.sha())
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url3.path))
            
            
            try repository.head().checkout(tag: tag1)
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: url2.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: url3.path))
            
            // get tag 1
            let getTag1 = try tags.get(name: "tag1")
            let getTag3 = try tags.get(name: "refs/tags/tag3")
            
            XCTAssertEqual("refs/tags/tag1", getTag1.name)
            XCTAssertEqual("refs/tags/tag3", getTag3.name)
            XCTAssertEqual("tag1", getTag1.shortName)
            XCTAssertEqual("tag3", getTag3.shortName)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
