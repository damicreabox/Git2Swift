//
//  Repository+Init.swift
//  Git2Swift
//
//  Created by Damien Giron on 31/07/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation
import CLibgit2

// MARK: - Repository extension for openning
extension Repository {
    
    /// Constructor with URL and manager
    ///
    /// - parameter url:     Repository URL
    /// - parameter manager: Repository manager
    ///
    /// - throws: GitError
    ///
    /// - returns: Repository
    convenience init(openAt url: URL, manager: RepositoryManager) throws {
        
        // Repository pointer
        let repository = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        // Init repo
        let error = git_repository_open(repository, url.path)
        if (error != 0) {
            repository.deinitialize()
            repository.deallocate(capacity: 1)
            throw gitUnknownError("Unable to open repository, url: \(url)", code: error)
        }
        
        self.init(at: url, manager: manager, repository: repository)
    }
    
    /// Init new repository at URL
    ///
    /// - parameter url:       Repository URL
    /// - parameter manager:   Repository manager
    /// - parameter signature: Initial commiter
    /// - parameter bare:      Create bare repository
    ///
    /// - throws: GitError
    ///
    /// - returns: Repository
    convenience init(initAt url: URL, manager: RepositoryManager, signature: Signature, bare: Bool) throws {
        
        // Repository pointer
        let repository = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        // Init repo
        let error = git_repository_init(repository, url.path, bare ? 1 : 0)
        if (error != 0) {
            repository.deinitialize()
            repository.deallocate(capacity: 1)
            throw gitUnknownError("Unable to init repository, url: \(url) (bare \(bare))", code: error)
        }
        
        self.init(at: url, manager: manager, repository: repository)
    }
    
    /// Clone a repository at URL
    ///
    /// - parameter url:            URL to remote git
    /// - parameter at:             URL to local respository
    /// - parameter manager:        Repository manager
    /// - parameter authentication: Authentication
    ///
    /// - throws: GitError wrapping libgit2 error
    ///
    /// - returns: Repository
    convenience init(cloneFrom url: URL,
                     at: URL,
                     manager: RepositoryManager,
                     authentication: AuthenticationHandler? = nil) throws {
        
        // Repository pointer
        let repository = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)
        
        var opts = git_clone_options()
        opts.version = 1
        opts.checkout_opts.version = 1
        opts.checkout_opts.checkout_strategy = GIT_CHECKOUT_SAFE.rawValue
        opts.fetch_opts.version = 1
        opts.fetch_opts.prune = GIT_FETCH_PRUNE_UNSPECIFIED
        opts.fetch_opts.update_fetchhead = 1
        
        opts.fetch_opts.callbacks.version = 1
        
        // Check handler
        if (authentication != nil) {
            setAuthenticationCallback(&opts.fetch_opts.callbacks, authentication: authentication!)
        }
        
        // Clone repository
        let error = git_clone(repository, url.absoluteString, at.path, &opts)
        if (error != 0) {
            repository.deinitialize()
            repository.deallocate(capacity: 1)
            throw gitUnknownError("Unable to clone repository, from \(url) to: \(at)", code: error)
        }
        
        self.init(at: at, manager: manager, repository: repository)
    }
}
