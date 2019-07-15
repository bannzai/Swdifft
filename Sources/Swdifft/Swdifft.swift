public typealias DefaultFomratter = DiffingFormatter
public typealias Content = String

public func printDiff(_ lhs: Content, _ rhs: Content, formatter: Formatter = DefaultFomratter()) {
    let (l, r) = diff(lhs, rhs)
    print(formatDiff(l, r))
}

public func formatDiff(_ lhs: Content, _ rhs: Content, formatter: Formatter = DefaultFomratter()) -> String {
    let (l, r) = diff(lhs, rhs)
    return formatter.format(lhs: l, rhs: r)
}

public func diff(_ lhs: Content, _ rhs: Content) -> (lhs: Content, rhs: Content) {
    return process(
        lhs: lhs,
        rhs: rhs,
        lcs: longestCommonSubsequence(lhs: lhs, rhs: rhs)
    )
}
