//
//  Strings.swift
//  Git2Swift
//
//  Created by Damien Giron on 31/07/2016.
//  Copyright © 2016 Creabox. All rights reserved.
//

import Foundation

/// Convert libgit2 string to Swift string
///
/// - parameter cStr: C string pointer
///
/// - returns: Swift string
func git_string_converter(_ cStr: UnsafePointer<CChar>) -> String {
    return String(cString: cStr)
}

/// Convert libgit2 string array to swift string array
///
/// - parameter strarray: libgit2 string array
///
/// - returns: String array
func git_strarray_to_strings(_ strarray: inout git_strarray) -> [String] {
    
    var strs = [String]()
    strs.reserveCapacity(strarray.count)
    for i in 0...(strarray.count - 1) {
        strs.append(String(cString: strarray.strings[i]!))
    }
    return strs
}
