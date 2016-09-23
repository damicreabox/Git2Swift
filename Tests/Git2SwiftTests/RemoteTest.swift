//
//  RemoteTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 17/08/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import XCTest

import Foundation

@testable import Git2Swift

class RemoteTest: XCTestCase {
    
    static let name = "remoteRepo"
    
    func testRemoteRepository() {
        
        do {
            
            // base repository
            let baseRepository = try RepositoryHelper.createRepository(name: RemoteTest.name + "Remotes")
            
            // List remotes
            XCTAssertEqual(0, try baseRepository.remotes.remoteNames().count)
            
            // Create remote
            _ = try baseRepository.remotes.create(name: "remote1",
                                                  url: URL(string: "http://localhost/tmp/")!)
            
            // List remotes
            XCTAssertEqual(1, try baseRepository.remotes.remoteNames().count)
            XCTAssertEqual("remote1", try baseRepository.remotes.remoteNames()[0])
            
            // Remove
            try baseRepository.remotes.remove(name: "remote1")
            XCTAssertEqual(0, try baseRepository.remotes.remoteNames().count)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testFetchRepository() {
        
        do {
            
            let repositoryManager = RepositoryManager()
            
            // base repository
            let baseRepository = try RepositoryHelper.createRepository(name: RemoteTest.name + "FetchBase")
            
            // Add file 1
            _ = try RepositoryHelper.addFile(repository: baseRepository, name: "file1")
            
            var baseNames = try baseRepository.branches.names()
            XCTAssertEqual(1, baseNames.count)
            XCTAssertEqual("refs/heads/master", baseNames[0])
            
            // Create repository at URL
            let clonedPath = try DirectoryManager.initDirectory(name: RemoteTest.name + "FetchClone")
            
            // Clone repo
            let cloneRepository = try repositoryManager.cloneRepository(from: baseRepository.url, at: clonedPath)
            
            var remoteNames = try cloneRepository.branches.names(type: BranchType.all)
            XCTAssertEqual(2, remoteNames.count)
            XCTAssertEqual("refs/heads/master", remoteNames[0])
            XCTAssertEqual("refs/remotes/origin/master", remoteNames[1])
            
            // Create new branch on base
            _ = try baseRepository.branches.create(name: "branch1")
            
            baseNames = try baseRepository.branches.names()
            XCTAssertEqual(2, baseNames.count)
            XCTAssertEqual("refs/heads/branch1", baseNames[0])
            XCTAssertEqual("refs/heads/master", baseNames[1])
            
            // Fetch new branches
            try cloneRepository.remotes.get(name: "origin").fetch()
            
            remoteNames = try cloneRepository.branches.names(type: BranchType.all)
            XCTAssertEqual(3, remoteNames.count)
            XCTAssertEqual("refs/heads/master", remoteNames[0])
            XCTAssertEqual("refs/remotes/origin/branch1", remoteNames[1])
            XCTAssertEqual("refs/remotes/origin/master", remoteNames[2])
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    
    func testPushRepository() {
        
        do {
            
            let repositoryManager = RepositoryManager()
            
            let basePath = try DirectoryManager.initDirectory(name: RemoteTest.name + "PullBase")
            
            // base repository
            let baseRepository = try repositoryManager.initRepository(at: basePath,
                                                                      signature: repositoryManager.systemSignature(), bare: true)
            
            var baseNames = try baseRepository.branches.names()
            XCTAssertEqual(1, baseNames.count)
            XCTAssertEqual("refs/heads/master", baseNames[0])
            
            // Create repository at URL
            let clonedPath = try DirectoryManager.initDirectory(name: RemoteTest.name + "PullClone")
            
            // Clone repo
            let cloneRepository = try repositoryManager.cloneRepository(from: baseRepository.url, at: clonedPath)
            
            var remoteNames = try cloneRepository.branches.names(type: BranchType.all)
            XCTAssertEqual(2, remoteNames.count)
            XCTAssertEqual("refs/heads/master", remoteNames[0])
            XCTAssertEqual("refs/remotes/origin/master", remoteNames[1])
            
            // Create new branch on base
            _ = try cloneRepository.branches.create(name: "branch1")
            
            remoteNames = try cloneRepository.branches.names()
            XCTAssertEqual(2, remoteNames.count)
            XCTAssertEqual("refs/heads/branch1", remoteNames[0])
            XCTAssertEqual("refs/heads/master", remoteNames[1])
            
            // Fetch new branches
            try cloneRepository.remotes.get(name: "origin").push(local: cloneRepository.branches.get(name: "branch1"))
            
            baseNames = try baseRepository.branches.names(type: BranchType.all)
            XCTAssertEqual(2, baseNames.count)
            XCTAssertEqual("refs/heads/branch1", baseNames[0])
            XCTAssertEqual("refs/heads/master", baseNames[1])
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testPullRepository() {
        
        do {
            
            let repositoryManager = RepositoryManager()
            
            // base repository
            let baseRepository = try RepositoryHelper.createRepository(name: RemoteTest.name + "PullBase")
            
            // Create repository at URL
            let clonedPath = try DirectoryManager.initDirectory(name: RemoteTest.name + "PullClone")
            
            // Add file 1
            let url1 = try RepositoryHelper.addFile(repository: baseRepository, name: "file1")
            let url1b = clonedPath.appendingPathComponent(url1.lastPathComponent)
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: url1b.path))
            
            // Clone repo
            let cloneRepository = try repositoryManager.cloneRepository(from: baseRepository.url, at: clonedPath)
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1b.path))
            
            // Add file 2
            let url2 = try RepositoryHelper.addFile(repository: baseRepository, name: "file2")
            let url2b = clonedPath.appendingPathComponent(url2.lastPathComponent)
            
            let commitBase = try baseRepository.head().targetCommit()
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: url2b.path))
            
            // Fetch new branches
            let result = try cloneRepository.remotes.get(name: "origin")
                .pull(signature: repositoryManager.systemSignature())
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1b.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2b.path))
            
            XCTAssertTrue(result)
            
            let commitClone = try cloneRepository.head().targetCommit()
            
            XCTAssertEqual(commitBase.summary, commitClone.summary)
            XCTAssertEqual(commitBase.oid.sha(), commitClone.oid.sha())
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
