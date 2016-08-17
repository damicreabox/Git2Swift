//
//  RepositoryHelper.swift
//  Git2Swift
//
//  Created by Damien Giron on 02/08/2016.
//
//

import Foundation

@testable import Git2Swift

class RepositoryHelper {
    
    static func createRepository(name: String) throws -> Repository {
        
        let repositoryManager = RepositoryManager()
        
        // Find reference test repository
        let directoryReference = try DirectoryManager.initDirectory(name: name)
        return try repositoryManager.initRepository(at: directoryReference, signature: repositoryManager.systemSignature())
    }
    
    static func addFile(repository: Repository, name: String, data: String? = nil, signature: Signature? = nil) throws -> URL {
        
        // Create file
        let url = try DirectoryManager.createFile(at: repository.url, name: name, data: data)
        
        // Create index
        let index1 = try repository.head().index()
        
        // Add item
        try index1.addItem(at: url)
        
        // Save
        try index1.save()
        
        // Find signature
        let sig : Signature
        if (signature == nil) {
            sig = try RepositoryHelper.systemSignature()
        } else {
            sig = signature!
        }
        
        // Commit
        _ = try index1.createCommit(msg: name, signature: sig)
        
        return url
    }
    
    static func systemSignature() throws -> Signature {
        return try RepositoryManager().systemSignature()
    }
}
