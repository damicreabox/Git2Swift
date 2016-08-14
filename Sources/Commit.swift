//
//  Commit.swift
//  Git2Swift
//
//  Created by Damien Giron on 01/08/2016.
//
//

import Foundation

/// Wrap a commit
public class Commit : Object {
    
    /// LibGit2 commit pointer
    internal let pointer : UnsafeMutablePointer<OpaquePointer?>
    
    /// OID
    public let oid: OID
    
    /// Commit summary
    lazy public var summary : String = {
        git_string_converter(git_commit_summary(self.pointer.pointee))
    } ()
    
    /// Commit body
    lazy public var body : String = {
        git_string_converter(git_commit_body(self.pointer.pointee))
    } ()
    
    /// Commit author
    lazy public var author : Signature = {
        Signature(sig: git_commit_author(self.pointer.pointee))
    } ()
    
    /// Commit commiter
    lazy public var committer : Signature = {
        Signature(sig: git_commit_committer(self.pointer.pointee))
    } ()
    
    /// Commit date
    lazy public var date : Date = {
        Date(timeIntervalSince1970: TimeInterval(git_commit_time(self.pointer.pointee)))
    } ()
    
    /// Commit TimeZone
    lazy public var timeZone : TimeZone? = {
        TimeZone(secondsFromGMT: Int(git_commit_time_offset(self.pointer.pointee)) * 60)
    } ()
    
    /// Constructor with libgit2 pointer and OID
    ///
    /// - parameter pointer: libgit2 commit pointer
    /// - parameter oid:     OID
    ///
    /// - returns: Commit
    init(pointer: UnsafeMutablePointer<OpaquePointer?>, oid: OID) {
        self.pointer = pointer
        self.oid = oid
    }
    
    deinit {
        if let ptr = pointer.pointee {
            git_commit_free(ptr)
        }
        pointer.deinitialize()
        pointer.deallocate(capacity: 1)
    }
}
