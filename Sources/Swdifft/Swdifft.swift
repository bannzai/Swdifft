struct Swdifft {
    var text = "Hello, World!"
}

public typealias DefaultFomratter = DiffingFormatter

public func diff(_ lhs: String, _ rhs: String, formatter: Formatter = DefaultFomratter()) -> [Diff] {
    return process(lhs: lhs, rhs: rhs, formatter: formatter)
}

private func process(lhs: String, rhs: String, formatter: Formatter) -> [Diff] {
    fatalError()
}
