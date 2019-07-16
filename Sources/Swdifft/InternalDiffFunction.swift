//
//  DiffFunctions.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/16.
//

import Foundation

internal func process(lhs: Content, rhs: Content, lcs: Content) -> (lhs: Content, rhs: Content) {
    let lhsLength = lhs.count
    let rhsLength = rhs.count
    let maxCount = min(lhsLength, rhsLength)
    
    struct Result {
        var stack: String = ""
        var beginDiff: Bool = false
    }
    
    func extract(target: Content, commonCharacter: Character, diffWords: (begin: String, end: String), beginIndex step: inout Int) -> Result {
        var result = Result()
        
        LOOP:
            for index in (step..<min(target.count, maxCount)) {
                step += 1
                switch commonCharacter == target[index] {
                case false:
                    switch result.beginDiff {
                    case false:
                        result.stack.append(contentsOf: diffWords.begin)
                        result.stack.append(target[index])
                        result.beginDiff = true
                    case true:
                        result.stack.append(target[index])
                    }
                case true:
                    if result.beginDiff {
                        result.stack.append(contentsOf: diffWords.end)
                        result.beginDiff = false
                    }
                    result.stack.append(target[index])
                    break LOOP
                }
        }
        if result.beginDiff {
            result.stack.append(contentsOf: diffWords.end)
            result.beginDiff = false
        }
        return result
    }
    
    var lhsBeginIndex = 0
    var rhsBeginIndex = 0
    let (lhsResult, rhsResult) = lcs.reduce((lhsResult: "", rhsResult: "")) { (result, commonCharacter) in
        return (
            result.0 + extract(target: lhs, commonCharacter: commonCharacter, diffWords: (begin: beginLHSMark, end: endLHSMark), beginIndex: &lhsBeginIndex).stack,
            result.1 + extract(target: rhs, commonCharacter: commonCharacter, diffWords: (begin: beginRHSMark, end: endRHSMark), beginIndex: &rhsBeginIndex).stack
            
        )
    }
    
    if lhsLength == rhsLength {
        return (lhs: lhsResult, rhs: rhsResult)
    }
    
    switch (lhsLength > rhsLength) {
    case true:
        return (lhs: lhsResult + beginLHSMark + lhs.suffix(from: maxCount) + endLHSMark, rhs: rhsResult)
    case false:
        return (lhs: lhsResult, rhs: rhsResult + beginRHSMark + rhs.suffix(from: maxCount) + endRHSMark)
    }
}
