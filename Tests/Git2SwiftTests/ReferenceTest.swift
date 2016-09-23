//
//  HeadTest.swift
//  Git2Swift
//
//  Created by Dami on 31/07/2016.
//
//

import XCTest

import Foundation

@testable import Git2Swift

class ReferenceTest : XCTestCase {
    
    static let repoName = "referenceTestRepo"
    
    func testReference() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: ReferenceTest.repoName)
            
            // Find HEAD
            let head = try repository.referenceLookup(name: "HEAD")
            XCTAssertEqual("HEAD", head.name)
            
            // Head type
            XCTAssertEqual(ReferenceType.symbolic, head.refType)
            
            
            let target = try head.targetReference()
            XCTAssertEqual(ReferenceType.oid, target.refType)
            
            let oid = try target.targetCommit().oid
            XCTAssertNotNil(oid.sha())
            
        } catch {
            XCTFail("\(error)")
        }
    }

}
