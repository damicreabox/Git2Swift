//
//  RepositoryTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 31/07/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import XCTest

import Foundation

@testable import Git2Swift

class RepositoryTest: XCTestCase {
    
    static let name = "repoConstructor"
    
    func testInitRepository() throws {
        
        do {
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: RepositoryTest.name + "Init")
            
            let initPath = repository.url
            
            XCTAssertEqual(initPath, repository.url)
            XCTAssert(FileManager.default.fileExists(atPath: initPath.appendingPathComponent(".git").path))
            
            // Find HEAD
            let head = try repository.head()
            XCTAssertEqual("HEAD", head.name)
            XCTAssertEqual("refs/heads/master", try head.targetReference().name)
            
        } catch  {
            XCTFail("\(error)")
        }
    }
    
    func testInitBareRepository() throws {
        
        do {
            
            let repositoryManager = RepositoryManager()
            
            // Create repository at URL
            let initPath = try DirectoryManager.initDirectory(name: RepositoryTest.name + "InitBare")
            
            // Create repo
            let repository = try repositoryManager.initRepository(at: initPath,
                                                                  signature: try repositoryManager.systemSignature(),
                                                                  bare: true)
            
            XCTAssertEqual(initPath, repository.url)
            XCTAssert(FileManager.default.fileExists(atPath: initPath.appendingPathComponent("HEAD").path))
            
        } catch  {
            XCTFail("\(error)")
        }
    }
    
    func testOpenRepository() throws {
        
        do {
            
            let repositoryManager = RepositoryManager()
            
            // Create repository at URL
            let initPath = try DirectoryManager.initDirectory(name: RepositoryTest.name + "Open")
            
            // Create repo
            let repository1 = try repositoryManager.initRepository(at: initPath,
                                                                   signature: try repositoryManager.systemSignature())
            // Create repo
            let repository2 = try repositoryManager.openRepository(at: initPath)
            
            XCTAssertEqual(initPath, repository1.url)
            XCTAssert(FileManager.default.fileExists(atPath: initPath.appendingPathComponent(".git").path))
            
            XCTAssertEqual(try repository1.head().targetCommit().oid.sha(),
                           try repository2.head().targetCommit().oid.sha())
            
        } catch  {
            XCTFail("\(error)")
        }
    }

    func testCloneRepository() throws {
        
        do {
            
            let cloneUrl = URL(string: "https://github.com/damicreabox/CLibgit2.git")
            guard cloneUrl != nil else {
                throw GitError.notFound(ref: "URL not found :-(")
            }
            
            let repositoryManager = RepositoryManager()
            
            // Create repository at URL
            let clonedPath = try DirectoryManager.initDirectory(name: RepositoryTest.name + "Clone")
            
            // Create repo
            let repository1 = try repositoryManager.cloneRepository(from: cloneUrl!, at: clonedPath)
            
            let iterator = try repository1.tags.all()
            let tag1 = iterator.next()
            
            XCTAssertEqual("refs/tags/1.0.0", tag1?.name)
            
            let remotes = repository1.remotes
            let remoteNames = try remotes.remoteNames()
            XCTAssertEqual(1, remoteNames.count)
            XCTAssertEqual("origin", remoteNames[0])
            
            let remote = try remotes.get(name: "origin")
            XCTAssertEqual("origin", remote.name)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
