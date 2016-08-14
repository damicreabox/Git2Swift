//
//  Merge.swift
//  Git2Swift
//
//  Created by Damien Giron on 08/08/2016.
//
//

import XCTest

@testable import Git2Swift

class MergeTest: XCTestCase {
    
    static let name = "mergeTest"
    
    func testUpToDate() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: MergeTest.name + "UpToDate")
            
            // Get branches
            let branches = repository.branches
            
            // Find master
            var branch = try branches.get(name: "master")
            
            // Add file 1
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1")
            
            // Find branch 1
            branch = try branches.create(name: "branch1")
            try repository.head().checkout(branch: branch)
            
            // Find master
            branch = try branches.get(name: "master")
            try repository.head().checkout(branch: branch)
            
            // Find master
            branch = try branches.get(name: "branch1")
            
            XCTAssertEqual(MergeType.upToDate, try repository.head().analysis(branch: branch))
            
        } catch {
            XCTFail("\(error)")
        }
    }

    
    func testNo() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: MergeTest.name + "No")
            
            // Get branches
            let branches = repository.branches
            
            // Add files
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 1")
            _ = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 1")
            _ = try RepositoryHelper.addFile(repository: repository, name: "file3", data: "Data content 1")
            
            // Find branch 1
            var branch = try branches.create(name: "branch1")
            try repository.head().checkout(branch: branch)
            
            // Add files
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 3")
            _ = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 2")
            _ = try RepositoryHelper.addFile(repository: repository, name: "file3", data: "Data content 1")
            
            // Find master
            branch = try branches.get(name: "master")
            try repository.head().checkout(branch: branch)
            
            // Add files
            _ = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data 1 content 1")
            _ = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data 2 content 2")
            _ = try RepositoryHelper.addFile(repository: repository, name: "file3", data: "Data 3 content 3")
            
            // Find branch 1
            branch = try branches.get(name: "branch1")
            
            XCTAssertEqual(MergeType.normal, try repository.head().analysis(branch: branch))
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testFastForward() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: MergeTest.name + "FastForward")
            
            let branches = repository.branches
            
            // Add file 1
            let url1 = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 1")
            
            // Check url1 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            
            // Find branch 1
            var branch = try branches.create(name: "branch1")
            try repository.head().checkout(branch: branch)
            
            // Add file 2
            let url2 = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 2")
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            
            // Find branch master
            branch = try branches.get(name: "master")
            try repository.head().checkout(branch: branch)
            
            // Check url2 not present
            XCTAssertFalse(FileManager.default.fileExists(atPath: url2.path))
            
            // Merge branch1
            _ = try repository.head().merge(branch: try branches.get(name: "branch1"),
                                            signature: try RepositoryHelper.systemSignature())
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testNormalMergeConflict() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: MergeTest.name + "NormalConflict")
            
            let branches = repository.branches
            
            // Add file 1
            let url1 = try RepositoryHelper.addFile(repository: repository, name: "file1", data: "Data content 1")
            
            // Check url1 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            
            // Find branch 1
            var branch = try branches.create(name: "branch1")
            try repository.head().checkout(branch: branch)
            
            // Add file 2
            var url2 = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 2 from branch 1")
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            
            // Find branch master
            branch = try branches.get(name: "master")
            try repository.head().checkout(branch: branch)
            
            // Check url2 not present
            XCTAssertFalse(FileManager.default.fileExists(atPath: url2.path))
            
            // Add file 2
            url2 = try RepositoryHelper.addFile(repository: repository, name: "file2", data: "Data content 2 from master")
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            
            branch = try branches.get(name: "branch1")
            let result = try repository.head().analysis(branch: branch)
            
            XCTAssertEqual(result, .normal)
            
            // Merge branch1
            _ = try repository.head().merge(branch: branch,
                                            signature: try RepositoryHelper.systemSignature())
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url2.path))
            
            // Test conflict
            XCTAssertTrue(try repository.head().index().conflicts)
            
            // All statues
            let statues = try repository.statuses.all()
            
            let status = statues.next()
            XCTAssertNotNil(status)
            XCTAssertEqual(StatusType.conflicted, status!.type)
            
            XCTAssertNil(statues.next())
            
        } catch {
            XCTFail("\(error)")
        }
    }

    
    func testNormalMergeOk() {
        
        do {
            
            // Create  repository
            let repository = try RepositoryHelper.createRepository(name: MergeTest.name + "NormalOk")
            
            let branches = repository.branches
            
            // Add file
            let url1 = try RepositoryHelper.addFile(repository: repository, name: "file", data: "Data content 1")
            
            // Check url1 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url1.path))
            
            // Find branch 1
            var branch = try branches.create(name: "branch1")
            try repository.head().checkout(branch: branch)
            
            // Add file 1
            let url11 = try RepositoryHelper.addFile(repository: repository, name: "file11", data: "from branch 1 \nData content 1")
            
            // Add file 2
            let url12 = try RepositoryHelper.addFile(repository: repository, name: "file12", data: "from branch 1 \nData content 1")
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url11.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url12.path))
            
            // Find branch master
            branch = try branches.get(name: "master")
            try repository.head().checkout(branch: branch)
            
            // Check url2 not present
            XCTAssertFalse(FileManager.default.fileExists(atPath: url11.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: url12.path))
            
            // Add files
            let url21 = try RepositoryHelper.addFile(repository: repository, name: "file21", data: "Data content 1 \n from master")
            let url22 = try RepositoryHelper.addFile(repository: repository, name: "file22", data: "Data content 1 \n from master")
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url21.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url22.path))
            
            branch = try branches.get(name: "branch1")
            let result = try repository.head().analysis(branch: branch)
            
            XCTAssertEqual(result, .normal)
            
            // Merge branch1
            _ = try repository.head().merge(branch: branch,
                                            signature: try RepositoryHelper.systemSignature())
            
            // Check url2 present
            XCTAssertTrue(FileManager.default.fileExists(atPath: url11.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url12.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url21.path))
            XCTAssertTrue(FileManager.default.fileExists(atPath: url22.path))
            
            // Test no conflict
            XCTAssertFalse(try repository.head().index().conflicts)
            
        } catch {
            XCTFail("\(error)")
        }
    }

}
