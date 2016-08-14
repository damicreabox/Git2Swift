//
//  Index+Files.swift
//  Git2Swift
//
//  Created by Damien Giron on 01/08/2016.
//
//

import Foundation

///
/// Find relative path to an other url.
///
func relativePath(from: URL, to: URL) -> String? {
    
    // Find current file path
    let currentFilePath = from.absoluteURL.path
    
    // Find from path
    let fromFilePath = to.path
    
    // Check if current URL is parent of from
    guard (currentFilePath.hasPrefix(fromFilePath)) else {
        return nil
    }
    
    // Find prefix size
    let size = fromFilePath.characters.count + (currentFilePath.characters[currentFilePath.startIndex] == "/" ? 1 : 0 )
    
    // Return sub string
    return currentFilePath.substring(from: currentFilePath.index(currentFilePath.startIndex, offsetBy: size))
}

// MARK: - Index extension for files
extension Index {
    
    /// Add item
    ///
    /// - parameter url: URL of the item
    ///
    /// - throws: GitError
    public func addItem(at url: URL) throws {
        
        // Create relative path
        guard let path = relativePath(from: url, to: repository.url) else {
            throw GitError.notFound(ref: url.absoluteString)
        }
        
        let error = git_index_add_bypath(idx.pointee, path);
        if (error != 0) {
            throw gitUnknownError("Unable to add item to index", code: error)
        }
    }
    
    /// Remove item
    ///
    /// - parameter url: URL of the item
    ///
    /// - throws: GitError
    public func removeItem(at url: URL) throws {
        
        // Create relative path
        guard let path = relativePath(from: url, to: repository.url) else {
            throw GitError.notFound(ref: url.absoluteString)
        }
        
        let error = git_index_remove_bypath(idx.pointee, path)
        if (error != 0) {
            throw gitUnknownError("Unable to remove item to index", code: error)
        }
    }
    
    /// Save index
    ///
    /// - throws: GitError
    public func save() throws {
        let error = git_index_write(idx.pointee)
        if (error != 0) {
            throw gitUnknownError("Unable to save index", code: error)
        }
    }
    
    /// Reload index
    ///
    /// - throws: GitError
    public func reload() throws {
        let error = git_index_read(idx.pointee, 1); // A for true
        if (error != 0) {
            throw gitUnknownError("Unable to read index", code: error)
        }
    }
    
    /// Clear index
    ///
    /// - throws: GitError
    public func clear() throws {
        let error = git_index_clear(idx.pointee);
        if (error != 0) {
            throw gitUnknownError("Unable to read index", code: error)
        }
    }
}
