struct Swdifft {
    var text = "Hello, World!"
}

public typealias DefaultFomratter = DiffingFormatter

public var beginLHSMark = "###"
public var endLHSMark = "###"

public var beginRHSMark = "***"
public var endRHSMark = "***"

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
    
    var rhsEndedIndex = 0
    
    struct Result {
        var stack: String = ""
        var beginDiff: Bool = false
    }

    func run(target: Content, commonCharacter: Character, diffWords: (begin: String, end: String)) -> Result {
        var endedIndex = 0
        var result = Result()
        
        for index in (endedIndex..<min(target.count, maxIndex)) {
            switch commonCharacter == target[index] {
            case false:
                switch result.beginDiff {
                case false:
                    result.stack.append(contentsOf: diffWords.end)
                    result.stack.append(target[index])
                    result.beginDiff = true
                case true:
                    result.stack.append(target[index])
                }
            case true:
                endedIndex = index
                break
            }
            if result.beginDiff {
                result.stack.append(contentsOf: diffWords.begin)
                result.beginDiff = false
            }
        }
        return result
    }

    let (lhsResult, rhsResult) = lcs.reduce((lhsResult: "", rhsResult: "")) { (result, commonCharacter) in
        return (
            result.0 + run(target: lhs, commonCharacter: commonCharacter, diffWords: (begin: beginLHSMark, end: endLHSMark)).stack,
            result.1 + run(target: rhs, commonCharacter: commonCharacter, diffWords: (begin: beginRHSMark, end: endRHSMark)).stack
        )
    }
    
    if lhsLength == rhsLength {
        return (lhs: lhsResult, rhs: rhsResult)
    }
    switch (lhsLength > rhsLength) {
    case false:
        let startIndex = lhs.index(lhs.startIndex, offsetBy: maxIndex)
        let endIndex = lhs.index(startIndex, offsetBy: lhsLength - maxIndex)
        return (lhs: lhsResult + lhs[startIndex..<endIndex], rhs: rhsResult)
    case true:
        let startIndex = lhs.index(lhs.startIndex, offsetBy: maxIndex)
        let endIndex = lhs.index(startIndex, offsetBy: lhsLength - maxIndex)
        return (lhs: lhsResult, rhs: rhsResult + rhs[startIndex..<endIndex])
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
}

internal extension String.Element {
    func string() -> String {
        return String(self)
    }
}
