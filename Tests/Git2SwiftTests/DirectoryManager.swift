//
//  TestDirectoryManager.swift
//  Git2Swift
//
//  Created by Damien Giron on 31/07/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation

class DirectoryManager {

    static let baseBase = URL(fileURLWithPath: "/var/tmp/git2swift")
    
    ///
    /// Temporary  directory.
    ///
    private static var temporaryDirectory : String? = nil
    
    ///
    /// Create temporary directory.
    /// - Returns URL of the temporary directory.
    ///
    private static func initBase() throws -> URL {
        
        if (true) {
            return baseBase
        }
        
        if (temporaryDirectory == nil) {
            temporaryDirectory = NSTemporaryDirectory().appending(NSUUID().uuidString)
            
            NSLog(" - Temporary path : \(temporaryDirectory)")
            
            let fileManager = FileManager.default
            if (!fileManager.fileExists(atPath: temporaryDirectory!)) {
                try fileManager.createDirectory(atPath: temporaryDirectory!,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
        }
        
        return URL(fileURLWithPath: temporaryDirectory!)
    }
    
    ///
    /// Init directory.
    /// - Parameter name : directory name.
    /// - Returns Test path correctly initialized.
    ///
    internal static func initDirectory(name: String) throws -> URL {
        
        // Create directory path
        let path = try DirectoryManager.initBase().appendingPathComponent(name)
        
        let fileManager = FileManager.default
        
        // Test directory exist
        if fileManager.fileExists(atPath: path.path) {
            try fileManager.removeItem(at: path)
        }
        
        // Create directory
        try fileManager.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        
        return path
    }
    
    internal static func createFile(at: URL, name: String, data: String? = nil) throws -> URL {
        
        let url = at.appendingPathComponent(name)
        
        // File manager
        let fileManager = FileManager.default
        
        // Check parent
        if (fileManager.fileExists(atPath: at.path)) {
            //try fileManager.removeItem(at: at)
        }
        
        NSLog(at.absoluteURL.path)
        
        let content : String
        if (data == nil) {
            content = name
        } else {
            content = data!
        }
        
        // Create file
        fileManager.createFile(atPath: url.absoluteURL.path,
                               contents: content.data(using: String.Encoding.utf8),
                               attributes: nil)
        
        return url
    }
}
