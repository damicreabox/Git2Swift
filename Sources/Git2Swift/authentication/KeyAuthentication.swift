//
//  KeyAuthentication.swift
//  Git2Swift
//
//  Created by Damien Giron on 11/09/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation

import CLibgit2

public protocol SshKeyData {
    
    /// Find user name
    var username : String? {
        get
    }
    
    /// Find public key URL
    var publicKey : URL {
        get
    }
    
    /// Find private key URL
    var privateKey : URL {
        get
    }
    
    /// Key pass phrase (may be nil)
    var passphrase : String? {
        get
    }
}

public struct RawSshKeyData : SshKeyData {
    public let username : String?
    public let publicKey : URL
    public let privateKey : URL
    public let passphrase : String?
    
    public init(username : String?, publicKey : URL, privateKey : URL, passphrase : String? = nil) {
        self.username = username
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.passphrase = passphrase
    }
}

/// Ssh key delegate
public protocol SshKeyDelegate {
    
    /// Get ssh key data
    ///
    /// - parameter username: username
    /// - parameter url:      url
    ///
    /// - returns: Password data
    func get(username: String?, url: URL?) -> SshKeyData
}

/// SSh authentication
public class SshKeyHandler : AuthenticationHandler {
    
    /// Delegate to access SSH key
    private let sshKeyDelegate: SshKeyDelegate
    
    public init(sshKeyDelegate: SshKeyDelegate) {
        self.sshKeyDelegate = sshKeyDelegate
    }
    
    /// Authentication
    ///
    /// - parameter out:      Git credential
    /// - parameter url:      url
    /// - parameter username: username
    ///
    /// - returns: 0 on ok
    public func authenticate(out: UnsafeMutablePointer<UnsafeMutablePointer<git_cred>?>?,
                             url: String?,
                             username: String?) -> Int32 {
        
        // Find ssh key data
        let sshKeyData = sshKeyDelegate.get(username: username, url: url == nil ? nil : URL(string: url!))
        
        // Public key
        let publicKey = sshKeyData.publicKey.path
        if (FileManager.default.fileExists(atPath: publicKey) == false) {
            return 1
        }
        
        // Private key
        let privateKey = sshKeyData.privateKey.path
        if (FileManager.default.fileExists(atPath: privateKey) == false) {
            return 2
        }
        
        // User name
        let optionalUsername = sshKeyData.username
        let optionalPassPhrase = sshKeyData.passphrase
        
        return git_cred_ssh_key_new(out,
                                    optionalUsername == nil ? "": optionalUsername!,
                                    publicKey,
                                    privateKey,
                                    optionalPassPhrase == nil ? "": optionalPassPhrase!)
    }
}
