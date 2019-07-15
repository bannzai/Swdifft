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
    let maxIndex = min(lhsLength, rhsLength) - 1
    
    struct Result {
        var stack: String = ""
        var beginDiff: Bool = false
    }
    
    func extract(target: Content, commonCharacter: Character, diffWords: (begin: String, end: String)) -> Result {
        var result = Result()
        
        LOOP:
            for index in (0..<min(target.count, maxIndex)) {
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
    
    let (lhsResult, rhsResult) = lcs.reduce((lhsResult: "", rhsResult: "")) { (result, commonCharacter) in
        let lTarget = lhs.suffix(from: result.0.replacingOccurrences(of: beginLHSMark, with: "").replacingOccurrences(of: endLHSMark, with: "").count)
        let rTarget = rhs.suffix(from: result.1.replacingOccurrences(of: beginRHSMark, with: "").replacingOccurrences(of: endRHSMark, with: "").count)
        return (
            result.0 + extract(target: lTarget, commonCharacter: commonCharacter, diffWords: (begin: beginLHSMark, end: endLHSMark)).stack,
            result.1 + extract(target: rTarget, commonCharacter: commonCharacter, diffWords: (begin: beginRHSMark, end: endRHSMark)).stack
            
        )
    }
    
    if lhsLength == rhsLength {
        return (lhs: lhsResult, rhs: rhsResult)
    }
    
    let from = maxIndex + 1
    switch (lhsLength > rhsLength) {
    case true:
        return (lhs: lhsResult + beginLHSMark + lhs.suffix(from: from) + endLHSMark, rhs: rhsResult)
    case false:
        return (lhs: lhsResult, rhs: rhsResult + beginRHSMark + rhs.suffix(from: from) + endRHSMark)
    }
}
