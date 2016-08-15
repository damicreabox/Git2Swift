//
//  OID.swift
//  Git2Swift
//
//  Created by Damien Giron on 31/07/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation

import XCTest

@testable import Git2Swift

class OIDTest: XCTestCase {

    func testOid() throws {
        
        // SHA
        let sha = "b716d746b9f652bf254300c770fdbe08cb15ce7e"
        
        // Create OID
        let oid1 = try OID(withSha: sha)
        
        XCTAssertEqual(sha, oid1.sha())
        
        // Create git oid
        let libgitoid1 = oid1.oid
        
        // Create OID from git
        let oid2 = OID(withGitOid: libgitoid1)
        
        XCTAssertEqual(sha, oid2.sha())
    }
    
    func testInvalid() throws {
        XCTAssertThrowsError(_ = try OID(withSha: "invalid"))
    }
}
