//
//  LinuxMain.swift
//  Git2Swift
//
//  Created by Dami on 24/09/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation

import XCTest

@testable import Git2Swift

XCTMain([
    testCase(BranchTest.allTests),
    testCase(CommitTest.allTests),
    testCase(HeadTest.allTests),
    testCase(IndexTest.allTests),
    testCase(MergeTest.allTests),
    testCase(OIDTest.allTests),
    testCase(ReferenceTest.allTests),
    testCase(RepositoryTest.allTests),
    testCase(TagTest.allTests),
    testCase(RemoteTest.allTests),
    testCase(AuthenticationTest.allTests),
    testCase(RevlogTest.allTests),
])
