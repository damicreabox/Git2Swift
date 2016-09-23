//
//  AuthenticationTest.swift
//  Git2Swift
//
//  Created by Damien Giron on 20/08/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import XCTest

import Foundation

@testable import Git2Swift

// --- Delegates ---

class StaticPasswordDelegate : PasswordDelegate {
    
    let passwordStr : String
    
    init(password: String) {
        self.passwordStr = password
    }
    
    public func get(username: String?, url: URL?) -> PasswordData {
        return RawPasswordData(username: username, password: passwordStr)
    }
}


class StaticSshKeyDelegate : SshKeyDelegate {
    
    let publicUrl: URL
    let privateUrl: URL
    
    init(publicUrl: URL, privateUrl: URL) {
        self.publicUrl = publicUrl
        self.privateUrl = privateUrl
    }
    
    public func get(username: String?, url: URL?) -> SshKeyData {
        return RawSshKeyData(username: username, publicKey: publicUrl, privateKey: privateUrl)
    }
}

// --- Config ---

class AuthenticationInfo {
    
    let authenticationTest : Bool
    let user : String
    let password : String
    let privateKeyFile : String
    let publicKeyFile : String
    
    static func readString(dictionnary: Dictionary<String, AnyObject>?,
                           key: String,
                           defaultValue: AnyObject) -> AnyObject {
        
        guard dictionnary != nil else {
            return defaultValue
        }
        
        // Find key
        let configObject = dictionnary![key]
        if (configObject == nil) {
            return defaultValue
        } else {
            return configObject!
        }
        
    }
    
    init(dictionnary: Dictionary<String, AnyObject>?) {
        
        authenticationTest = AuthenticationInfo.readString(dictionnary: dictionnary,
                                            key:"authenticationTest",
                                            defaultValue: false as AnyObject) as! Bool
        user = AuthenticationInfo.readString(dictionnary: dictionnary,
                                            key:"login",
                                            defaultValue: "" as AnyObject) as! String
        password = AuthenticationInfo.readString(dictionnary: dictionnary,
                                            key:"password",
                                            defaultValue: "" as AnyObject) as! String
        privateKeyFile = AuthenticationInfo.readString(dictionnary: dictionnary,
                                            key:"privateKey",
                                            defaultValue: "" as AnyObject) as! String
        publicKeyFile = AuthenticationInfo.readString(dictionnary: dictionnary,
                                            key:"publicKey",
                                            defaultValue: "" as AnyObject) as! String
    }
    
    convenience init(data: Data?) {
        
        var dictionnary : Dictionary<String, AnyObject>?
        
        do {
            dictionnary = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, AnyObject>
        } catch {
            print(error)
        }
        
        self.init(dictionnary: dictionnary)
    }
}

class AuthenticationTest: XCTestCase {
    
    static let name = "repoAuthentication"
    
    func testCloneRepository() throws {
        
        // Process Info
        let dict = ProcessInfo.processInfo.environment
        
        // Find config file 
        let configFile = dict["AUTH_CONFIG_TEST_FILE"]
        if (configFile == nil) {
            NSLog("Auth test disabled : No config file")
            return
        }
        
        let authenticationInfo = AuthenticationInfo(data: FileManager.default.contents(atPath: configFile!))
        
        guard authenticationInfo.authenticationTest else {
            NSLog("Authentication not set, so not tested");
            return
        }
        
        let user = authenticationInfo.user
        
        do {
            
            let basePath = try DirectoryManager.initDirectory(name: AuthenticationTest.name + "Base")
            
            let repositoryManager = RepositoryManager()
            
            // base repository
            let baseRepository = try repositoryManager.initRepository(at: basePath,
                                                                      signature: repositoryManager.systemSignature(),bare: true)
            
            let cloneUrl = URL(string: "ssh://\(user)@localhost\(baseRepository.url.path)")
            guard cloneUrl != nil else {
                throw GitError.notFound(ref: "URL not found :-(")
            }
            
            // Create repository at URL
            let clonedPasswordPath = try DirectoryManager.initDirectory(name: RepositoryTest.name + "PasswordClone")
            
            // Create repo
            let repository1 = try repositoryManager.cloneRepository(from: cloneUrl!,
                                                                    at: clonedPasswordPath,
                                                                    authentication: PasswordHandler(
                                                                        passwordDelegate: StaticPasswordDelegate(password: authenticationInfo.password)))
            
            XCTAssertEqual("Initial commit", try repository1.head().targetCommit().summary)
            
            // Create repository at URL
            let clonedKeyPath = try DirectoryManager.initDirectory(name: RepositoryTest.name + "KeyClone")
            
            
            // Public key
            let publickeyUrl = URL(string: authenticationInfo.publicKeyFile)
            let privatekeyUrl = URL(string: authenticationInfo.privateKeyFile)
            
            if (publickeyUrl == nil || privatekeyUrl == nil) {
                XCTFail("No ssh key")
            } else {
                
                let sshKeyDelegate = StaticSshKeyDelegate(publicUrl:publickeyUrl!,
                                                          privateUrl:privatekeyUrl!)
                
                // Create repo
                let repository2 = try repositoryManager.cloneRepository(from: cloneUrl!,
                                                                        at: clonedKeyPath,
                                                                        authentication: SshKeyHandler(
                                                                            sshKeyDelegate: sshKeyDelegate))
                
                XCTAssertEqual("Initial commit", try repository2.head().targetCommit().summary)
            }
            
        } catch  {
            XCTFail("\(error)")
        }
    }
}

