struct Swdifft {
    var text = "Hello, World!"
}

public typealias DefaultFomratter = DiffingFormatter

public var beginLHSMark = "###"
public var endLHSMark = "###"

public var beginRHSMark = "***"
public var endRHSMark = "***"

public typealias Content = String

public func diff(_ lhs: Content, _ rhs: Content, formatter: Formatter = DefaultFomratter()) -> [Diff] {
    return process(lhs: lhs, rhs: rhs, formatter: formatter)
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

private func process(lhs: Content, rhs: Content, formatter: Formatter) -> [Diff] {
    fatalError()
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
