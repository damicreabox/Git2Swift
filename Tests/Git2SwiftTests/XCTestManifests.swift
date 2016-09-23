//
//  XCTestManifests.swift
//  Git2Swift
//
//  Created by Dami on 15/08/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

extension BranchTest {
    
    static var allTests = [
        ("testAll", testAll),
        ("testSwitchBranch", testSwitchBranch),
        ("testCreateDeleteBranch", testCreateDeleteBranch),
        ("testIteratorBranch", testIteratorBranch)
    ]
}

extension CommitTest {
    
    static var allTests = [
        ("testReference", testReference)
    ]
    
}

extension HeadTest {
    
    static var allTests = [
        ("testResetHead", testResetHead)
    ]
    
}

extension IndexTest {
    
    static var allTests = [
        ("testReference", testReference)
    ]
    
}


extension MergeTest {
    
    static var allTests = [
        ("testUpToDate", testUpToDate),
        ("testNo", testNo),
        ("testFastForward", testFastForward),
        ("testNormalMergeConflict", testNormalMergeConflict),
        ("testNormalMergeOk", testNormalMergeOk)
    ]
    
}

extension OIDTest {
    
    static var allTests = [
        ("testOid", testOid)
    ]
    
}

extension ReferenceTest {
    
    static var allTests = [
        ("testReference", testReference)
    ]
    
}

extension RepositoryTest {
    
    static var allTests = [
        ("testInitRepository", testInitRepository),
        ("testInitBareRepository", testInitBareRepository),
        ("testOpenRepository", testOpenRepository)
    ]
    
}

extension TagTest {
    
    static var allTests = [
        ("testAll", testAll)
    ]
    
}

extension RemoteTest {
    
    static var allTests = [
        ("testRemoteRepository", testRemoteRepository),
        ("testFetchRepository", testFetchRepository),
        ("testPushRepository", testPushRepository)
    ]
    
}

extension AuthenticationTest {
    
    static var allTests = [
        ("testCloneRepository", testCloneRepository)
    ]
    
}

extension RevlogTest {
    
    static var allTests = [
        ("testFileLog", testFileLog)
    ]
}
