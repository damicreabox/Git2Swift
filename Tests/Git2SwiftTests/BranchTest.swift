//
//  BranchTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 01/08/2016.
//
//

import XCTest

@testable import Git2Swift

class BranchTest: XCTestCase {
    
    static let name = "branchTest"
    
    func testAll() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: BranchTest.name + "All")
            
            // Get branches
            let branches = repository.branches
            
            // Find master
            let masterBranch = try branches.get(name: "master")
            
            // Find master
            let fullNameMasterBranch = try branches.get(spec: "refs/heads/master")
            
            XCTAssertEqual(masterBranch.name, fullNameMasterBranch.name)
            
            // Find invalid branch
            XCTAssertThrowsError(try branches.get(name: "branch"))
            
            XCTAssertEqual("refs/heads/master", masterBranch.name)
            XCTAssertEqual("master", masterBranch.shortName)
            XCTAssertEqual(BranchType.local, masterBranch.type)
            
            // Add file 1
            let url1 = try RepositoryHelper.addFile(repository: repository, name: "file1")
            
            // Check url1 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            
            // Create branch 1
            let branch1 = try repository.branches.create(name: "branch1")
            XCTAssertEqual("refs/heads/branch1", branch1.name)
            XCTAssertEqual(BranchType.local, branch1.type)
            
            // Check url1 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            
            // Add file 2
            let url2 = try RepositoryHelper.addFile(repository: repository, name: "file1")
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            
            // Switch branch1
            try repository.head().checkout(branch: branch1)
            XCTAssertEqual("refs/heads/branch1", try repository.head().targetReference().name)
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            
            // Check url1 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            
            // Test merge
            XCTAssertEqual(MergeType.upToDate, try repository.head().analysis(branch: branch1))
            
            // Add file 3
            let url3 = try RepositoryHelper.addFile(repository: repository, name: "file3")
            
            // Switch master
            try repository.head().checkout(branch: repository.branches.get(name: "master"))
            XCTAssertEqual("refs/heads/master", try repository.head().targetReference().name)
            
            // Check url1 not present
            XCTAssertFalse(FileManager.default.fileExists(atPath: url3.path))
            
            // Test merge
            let branch11 = try repository.branches.get(name: "branch1")
            XCTAssertEqual(MergeType.normal, try repository.head().analysis(branch: branch11))
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    
    func testSwitchBranch() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: BranchTest.name + "Switch")
            
            let branches = repository.branches
            
            // Add file 1
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 1")
            
            // Find branch 1
            var branch = try branches.create(name: "branch1")
            try repository.head().checkout(branch: branch)
            
            // Add file 2
            _ = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 2")
            
            // Find branch master
            branch = try branches.get(name: "master")
            try repository.head().checkout(branch: branch)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    
    func testCreateDeleteBranch() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: BranchTest.name + "CreateDelete")
            
            let branches = repository.branches
            
            // Add file 1
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 1")
            
            // Find branch 1
            var branch = try branches.create(name: "branch1")
            
            // Find create same
            XCTAssertThrowsError(try branches.create(name: "branch1"))
            
            // Switch to branch
            try repository.head().checkout(branch: branch)
            
            
            // Add file 2
            _ = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 2")
            
            // Find branch master
            branch = try branches.get(name: "master")
            try repository.head().checkout(branch: branch)
            
            // Delete branch1
            try repository.branches.remove(name: "branch1")
            
            // Test delete branch1
            XCTAssertThrowsError(try repository.branches.get(name: "branch1"))
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testIteratorBranch() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: BranchTest.name + "Iterator")
            
            let branches = repository.branches
            
            // Create branches
            _ = try branches.create(name: "branch1")
            _ = try branches.create(name: "branch2")
            _ = try branches.create(name: "branch3")
            
            // Create iterator
            let iterator = try branches.all()
            
            // Find first
            let branch1 = iterator.next()
            XCTAssertNotNil(branch1)
            XCTAssertEqual("refs/heads/branch1", branch1!.name)
            
            // Find second
            let branch2 = iterator.next()
            XCTAssertNotNil(branch1)
            XCTAssertEqual("refs/heads/branch2", branch2!.name)
            
            // Find third
            let branch3 = iterator.next()
            XCTAssertNotNil(branch1)
            XCTAssertEqual("refs/heads/branch3", branch3!.name)
            
            // Find fourth
            let branch4 = iterator.next()
            XCTAssertNotNil(branch1)
            XCTAssertEqual("refs/heads/master", branch4!.name)
            
            // Last
            let end = iterator.next()
            XCTAssertNil(end)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
