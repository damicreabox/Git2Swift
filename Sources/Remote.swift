//
//  Remote.swift
//  Git2Swift
//
//  Created by Damien Giron on 17/08/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation

import CLibgit2

/// Define remote repository.
public class Remote {
    
    /// Repository
    let repository : Repository
    
    /// Remote name
    public let name: String
    
    /// Remote pointer
    internal let pointer: UnsafeMutablePointer<OpaquePointer?>
    
    /// Constructor with repository, pointer and name
    ///
    /// - parameter repository: repository
    /// - parameter pointer:    pointer
    /// - parameter name:       name
    ///
    /// - returns: Remote
    init(repository: Repository, pointer: UnsafeMutablePointer<OpaquePointer?>, name: String) {
        self.repository = repository
        self.name = name
        self.pointer = pointer
    }
    
    
    /// Fetch all remote branches
    /// - parameter authentication: Authentication callback, maybe nil
    ///
    /// - throws: GitError
    public func fetch(authentication: AuthenticationHandler? = nil) throws {
        
        // Define fetch options
        var fetchOptions = git_fetch_options()
        fetchOptions.version = 1
        fetchOptions.callbacks.version = 1
        fetchOptions.prune = GIT_FETCH_PRUNE_UNSPECIFIED
        fetchOptions.update_fetchhead = 1
        
        // test authentication
        if (authentication != nil) {
            setAuthenticationCallback(&fetchOptions.callbacks, authentication: authentication)
        }
        
        // Fetch remote
        let error = git_remote_fetch(pointer.pointee, nil, &fetchOptions, nil)
        if (error != 0) {
            throw gitUnknownError("Unable to fetch from remote", code: error)
        }
    }
    
    /// Pull all remote branches
    ///
    /// - parameter signature: Signature
    /// - parameter remote: Remote branch to merge
    /// - parameter authentication: Authentication callback, maybe nil
    ///
    /// - throws: GitError
    public func pull(signature: Signature, remote: Branch? = nil,
                     authentication: AuthenticationHandler? = nil) throws -> Bool {
        
        // Fetch remote
        try fetch(authentication: authentication)
        
        let remoteBranch: Branch
        
        if (remote == nil) {
            
            // Find spec informations
            let specInfo = try Branch.getSpecInfo(spec: repository.head().targetReference().name)
            
            // Find remote branch
            remoteBranch = try repository.branches.get(name: "\(name)/\(specInfo.name)", type: .remote)
        } else {
            remoteBranch = remote!
        }
        
        // Merge head
        return try repository.head().merge(branch: remoteBranch, signature: signature)
    }
    
    /// Push a branch to remote
    ///
    /// - parameter local:  Local branch
    /// - parameter remote: Remote branch or nil for same remote branch
    /// - parameter authentication: Authentication callback, maybe nil
    ///
    /// - throws: GitError
    public func push(local: Branch, remote: Branch? = nil,
                     authentication: AuthenticationHandler? = nil) throws {
   
        // Set options
        var opts = git_push_options()
        opts.version = 1
        opts.callbacks.version = 1
        
        // test authentication
        if (authentication != nil) {
            setAuthenticationCallback(&opts.callbacks, authentication: authentication)
        }
        
        // Create refspec
        let refspec : String
        if (remote == nil) {
            refspec = "\(local.name):\(local.name)"
        } else {
            refspec = "\(local.name):refs/heads/\(remote!.shortName)"
        }
        
        // Create refspecs
        let wrapper = StringWrapper(withStrs: [refspec])
        
        // Create str array
        var refspecs = git_strarray(strings: wrapper.pointer, count:  wrapper.count)

        let error = git_remote_push(pointer.pointee, &refspecs, &opts);
        if (error != 0) {
            throw gitUnknownError("Unable to push to remote", code: error)
        }
    }
}
