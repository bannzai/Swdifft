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
    
    func extractInBackground(closure: @escaping (Content) -> (), target: Content, diffWords: (begin: String, end: String)) {
        var beginIndex = 0
        DispatchQueue.global().async {
            let r = lcs.reduce("") { (result, commonCharacter) in
                return result + extract(target: target, commonCharacter: commonCharacter, diffWords: (begin: diffWords.begin, end: diffWords.end), beginIndex: &beginIndex).stack
            }
            
            closure(r)
        }
    }
    
    var lhsResult = ""
    var rhsResult = ""
    
    extractInBackground(closure: { lhsResult = $0 }, target: lhs, diffWords: (begin: beginLHSMark, end: endLHSMark))
    extractInBackground(closure: { rhsResult = $0 }, target: rhs, diffWords: (begin: beginRHSMark, end: endRHSMark))
    
    // Wait for background task.
    while lhsResult.isEmpty || rhsResult.isEmpty { }

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
