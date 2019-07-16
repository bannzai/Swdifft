//
//  longestCommonSubsequence.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/16.
//

import Foundation

internal func longestCommonSubsequence(lhs: Content, rhs: Content) -> Content {
    var lcs = ""
    let maxIndex = min(lhs.count, rhs.count) - 1
    var storedStartIndex = 0
    for i in (0...maxIndex) {
        for j in (storedStartIndex...maxIndex) {
            if lhs[i] == rhs[j] {
                storedStartIndex = j
                lcs.append(rhs[storedStartIndex])
                continue
            }
        }
    }
    return lcs
}

