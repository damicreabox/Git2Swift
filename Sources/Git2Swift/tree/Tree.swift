//
//  Tree.swift
//  Git2Swift
//
//  Created by Damien Giron on 01/08/2016.
//
//

import Foundation
import CLibgit2

/// Tree Definition
public class Tree {
    
    /// Internal libgit2 tree
    internal let tree : UnsafeMutablePointer<OpaquePointer?>
    
    /// Init with libgit2 tree
    ///
    /// - parameter repository: Git2Swift repository
    /// - parameter tree:       Libgit2 tree pointer
    ///
    /// - returns: Tree
    init(repository: Repository, tree : UnsafeMutablePointer<OpaquePointer?>) {
        self.tree = tree
    }
    
    deinit {
        
        if let ptr = tree.pointee {
            git_tree_free(ptr)
        }
        
        tree.deinitialize()
        tree.deallocate(capacity: 1)
    }
}
