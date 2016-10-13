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
    
    let repository : Repository
    
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
        self.repository = repository
    }
    
    deinit {
        
        if let ptr = tree.pointee {
            git_tree_free(ptr)
        }
        
        tree.deinitialize()
        tree.deallocate(capacity: 1)
    }
    
    /// The number of entries in this tree
    lazy public var count : Int = {
        git_tree_entrycount(self.tree.pointee)
    } ()

    /// List of file names in the tree
    ///
    /// parameter tree: Pointer to tree type
    ///
    /// returns List of files in tree
    public func files() throws -> [String] {
        return try files(tree: self.tree.pointee)
    }

    /// List of file names in the tree
    ///
    /// parameter tree: Pointer to tree type
    ///
    /// returns List of files in tree
    public func files(tree: OpaquePointer?, root: String = "") throws -> [String] {
        var ff: [String] = []
        let count = git_tree_entrycount(tree)
        for ii in 0..<count {
            let entry = git_tree_entry_byindex(tree, ii)
            let cname = git_tree_entry_name(entry)
            let name = String(cString: cname!)
            let type = git_tree_entry_type(entry)

            // if this is a sub-tree we must parse it
            if type == GIT_OBJ_TREE {
                let pointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
                let error = git_tree_entry_to_object(pointer, repository.pointer.pointee, entry)

                guard error == 0 else {
                    pointer.deinitialize()
                    pointer.deallocate(capacity: 1)
                    throw gitUnknownError("Unable to create object", code: error)
                }

                ff += try files(tree: pointer.pointee, root: "\(root)\(name)/")
                if let ptr = pointer.pointee {
                    git_object_free(ptr)
                }
                pointer.deinitialize()
                pointer.deallocate(capacity: 1)
            } else {
                ff.append("\(root)\(name)")
            }
        }
        return ff
    }

    /// Find entry by path.
    ///
    /// - parameter byPath: Path of file
    ///
    /// - throws: GitError
    ///
    /// - returns: TreeEntry or nil
    public func entry(byPath: String) throws -> TreeEntry? {
        
        // Entry
        let treeEntry = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        // Find tree entry
        let error = git_tree_entry_bypath(treeEntry, tree.pointee, byPath)
        switch error {
        case 0:
            return TreeEntry(pointer: treeEntry)
        case GIT_ENOTFOUND.rawValue:
            return nil
        default:
            throw GitError.unknownError(msg: "", code: error, desc: git_error_message())
        }
        
    }
    
    /// Diff
    ///
    /// - parameter other: Other tree
    ///
    /// - returns: Diff
    public func diff(other: Tree) throws -> Diff {
        
        // Create diff
        let diff = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        // Create diff
        let error = git_diff_tree_to_tree(diff, repository.pointer.pointee,
                                          tree.pointee,
                                          other.tree.pointee, nil)
        if (error == 0) {
            return Diff(pointer: diff)
        } else {
            throw GitError.unknownError(msg: "diff", code: error, desc: git_error_message())
        }
    }
}
