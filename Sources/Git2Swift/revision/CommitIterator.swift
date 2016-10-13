//
//  CommitIterator.swift
//  Git2Swift
//
//

import Foundation

import CLibgit2

public class CommitIterator: Sequence, IteratorProtocol {

    /// Repository
    let repository: Repository

    /// Libgit2 pointer
    internal let pointer: UnsafeMutablePointer<OpaquePointer?>

    public init(repository: Repository, refspec: String = "HEAD") throws {
        // Create walker
        let walker = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: 1)

        // Init walker
        var error = git_revwalk_new(walker, repository.pointer.pointee)
        guard error == 0 else {
            walker.deinitialize()
            walker.deallocate(capacity: 1)
            throw gitUnknownError("Unable to create rev walker for '\(refspec)'", code: error)
        }

        // Push reference
        error = git_revwalk_push_ref(walker.pointee, refspec)
        guard error == 0 else {
            walker.deinitialize()
            walker.deallocate(capacity: 1)
            throw gitUnknownError("Unable to set rev walker for '\(refspec)'", code: error)
        }

        self.repository = repository
        self.pointer = walker
    }

    deinit {
        if let ptr = pointer.pointee {
            git_revwalk_free(ptr)
        }
        pointer.deinitialize()
        pointer.deallocate(capacity: 1)
    }

    public func nextOid() -> OID? {
        var gitOid = git_oid()
        if git_revwalk_next(&gitOid, pointer.pointee) == 0 {
            return OID(withGitOid: gitOid)
        } else {
            return nil
        }
    }

    /// Next value
    ///
    /// - returns: Next value or nil
    public func next() -> Commit? {
        guard let oid = nextOid() else {
            return nil
        }

        do {
            // Find commit
            return try repository.commitLookup(oid: oid)
        } catch {
            NSLog("Unable to find next OID \(error)")
        }

        return nil
    }
}
