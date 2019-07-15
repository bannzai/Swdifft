struct Swdifft {
    var text = "Hello, World!"
}

public typealias DefaultFomratter = DiffingFormatter

public var beginLHSMark = "`"
public var endLHSMark = "`"

public var beginRHSMark = "*"
public var endRHSMark = "*"

public typealias Content = String

public func diff(_ lhs: Content, _ rhs: Content, formatter: Formatter = DefaultFomratter()) -> (lhs: Content, rhs: Content) {
    return process(
        lhs: lhs,
        rhs: rhs,
        lcs: longestCommonSubsequence(lhs: lhs, rhs: rhs),
        formatter: formatter
    )
}

internal func longestCommonSubsequence(lhs: Content, rhs: Content) -> Content {
    var lcs = ""
    let maxIndex = min(lhs.count, rhs.count) - 1
    var storedStartIndex = 0
    for i in (0...maxIndex) {
        for j in (storedStartIndex...maxIndex) {
            if lhs[i] == rhs[j] {
                storedStartIndex = j
                lcs.append(rhs[storedStartIndex])
            }
        }
    }
    return lcs
}

private func process(lhs: Content, rhs: Content, lcs: Content, formatter: Formatter) -> (lhs: Content, rhs: Content) {
    let lhsLength = lhs.count
    let rhsLength = rhs.count
    let maxIndex = min(lhsLength, rhsLength) - 1
    
    struct Result {
        var stack: String = ""
        var beginDiff: Bool = false
    }

    func run(target: Content, commonCharacter: Character, diffWords: (begin: String, end: String)) -> Result {
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
            result.0 + run(target: lTarget, commonCharacter: commonCharacter, diffWords: (begin: beginLHSMark, end: endLHSMark)).stack,
            result.1 + run(target: rTarget, commonCharacter: commonCharacter, diffWords: (begin: beginRHSMark, end: endRHSMark)).stack
            
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


internal extension String {
    subscript(safe offset: Int) -> String.Element? {
        return offset > count ? nil : self[offset]
    }
    subscript(offset: Int) -> String.Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    func prefix(offset: Int) -> String {
        return String(prefix(upTo: index(startIndex, offsetBy: offset)))
    }
    func suffix(from offset: Int) -> String {
        return String(suffix(from: index(startIndex, offsetBy: offset)))
    }
}

internal extension String.Element {
    func string() -> String {
        return String(self)
    }
}
