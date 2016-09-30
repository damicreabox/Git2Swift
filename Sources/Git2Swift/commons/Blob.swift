//
//  Blob.swift
//  Git2Swift
//
//

import Foundation
import CLibgit2

/// Tree Definition
public class Blob {

    /// Internal libgit2 tree
    internal let blob: UnsafeMutablePointer<OpaquePointer?>

    /// Init with libgit2 tree
    ///
    /// - parameter repository: Git2Swift repository
    /// - parameter Blob:       Libgit2 blob pointer
    ///
    /// - returns: Blob
    init(blob: UnsafeMutablePointer<OpaquePointer?>) {
        self.blob = blob
    }

    deinit {
        if let ptr = blob.pointee {
            git_blob_free(ptr)
        }

        blob.deinitialize()
        blob.deallocate(capacity: 1)
    }

    lazy public var rawContent: Data = {
        Data(bytes: git_blob_rawcontent(self.blob.pointee),
            count: Int(truncatingBitPattern: git_blob_rawsize(self.blob.pointee)))
    }()
}
