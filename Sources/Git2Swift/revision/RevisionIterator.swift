//
//  RevisionIterator.swift
//  Git2Swift
//
//  Created by Damien Giron on 14/09/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation

import CLibgit2

/// Revision iterator
///
/// Iterate over commits
///
public class RevisionIterator : Sequence, IteratorProtocol {
    
    /// Repository
    let repository: Repository
    
    /// Libgit2 pointer
    internal let pointer: UnsafeMutablePointer<OpaquePointer?>
    
    init(repository: Repository,
         pointer: UnsafeMutablePointer<OpaquePointer?>) {
        self.repository = repository
        self.pointer = pointer
    }
    
    deinit {
        if let ptr = pointer.pointee {
            git_revwalk_free(ptr)
        }
        pointer.deinitialize()
        pointer.deallocate(capacity: 1)
    }
    
    /// Find next oid
    ///
    /// - returns: Next branch or nil for the end
    public func next() -> OID? {
        
        var gitOid = git_oid()
        
        if git_revwalk_next(&gitOid, pointer.pointee) == 0 {
            return OID(withGitOid: gitOid)
        } else {
            return nil
        }
    }
}
