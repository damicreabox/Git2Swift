//
//  Repository.swift
//  Git2Swift
//
//  Created by Damien Giron on 31/07/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation
import CLibgit2

/// Repository wrapping a libgit2 repository
public class Repository {
    
    /// Repository URL
    public let url : URL
    
    /// Repository manager
    private let manager : RepositoryManager
    
    /// Libgit2 pointer to repository
    internal let pointer : UnsafeMutablePointer<OpaquePointer?>
    
    /// Branches manager
    lazy public private(set) var branches : Branches = {
        Branches(withRepository: self)
    } ()
    
    /// Statuses manager
    lazy public private(set) var statuses : Statuses = {
        Statuses(repository: self)
    } ()
    
    /// Access tags manager
    lazy public private(set) var tags : Tags = {
        Tags(repository: self)
    } ()
    
    /// Constructor with repository manager and libgit2 repository
    ///
    /// - parameter url:        URL repository
    /// - parameter manager:    Repository manager
    /// - parameter repository: Libgit2 repository
    ///
    /// - returns: Repository
    init(at url: URL, manager: RepositoryManager, repository: UnsafeMutablePointer<OpaquePointer?>) {
        self.url = url
        self.manager = manager
        self.pointer = repository
    }
    
    deinit {
        if let ptr = pointer.pointee {
            git_repository_free(ptr)
        }
        pointer.deinitialize()
        pointer.deallocate(capacity: 1)
    }
    
    /// Retrieve head
    ///
    /// - throws: GitError
    ///
    /// - returns: Head
    public func head() throws -> Head {
        // Create head
        return try Head(repository: self, name: "HEAD", pointer: try gitReferenceLookup(repository: pointer, name: "HEAD"))
    }
}
