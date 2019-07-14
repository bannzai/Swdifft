struct Swdifft {
    var text = "Hello, World!"
}

public typealias DefaultFomratter = DiffingFormatter

public var beginLHSMark = "###"
public var endLHSMark = "###"

public var beginRHSMark = "***"
public var endRHSMark = "***"

public typealias Content = String

internal struct EditGraph {
    typealias List = ContiguousArray<Int>
    private(set) var graph: ContiguousArray<List>

    init(horizontal x: Content, vertical y: Content) {
        var column = List(repeating: 0, count: y.count + 1)
        column.reserveCapacity(column.count)
        
        graph = ContiguousArray<List>(repeating: column, count: x.count + 1)
        graph.reserveCapacity(graph.count)

        configure(horizontal: x, vertical: y)
    }
    
    private mutating func configure(
        horizontal x: Content,
        vertical y: Content
        ) {
        if x.isEmpty || y.isEmpty {
            fatalError()
        }
        
        for xIndex in (1..<graph.indices.endIndex) {
            for yIndex in (1..<graph[xIndex].indices.endIndex) {
                let addition = x[xIndex - 1] == y[yIndex - 1] ? 1 : 0
                graph[xIndex][yIndex] = max(
                    graph[xIndex - 1][yIndex - 1] + addition,
                    graph[xIndex - 1][yIndex],
                    graph[xIndex][yIndex - 1]
                )
            }
        }
    }
}

public func diff(_ lhs: Content, _ rhs: Content, formatter: Formatter = DefaultFomratter()) -> [Diff] {
    return process(lhs: lhs, rhs: rhs, formatter: formatter)
}

private func process(lhs: String, rhs: String, formatter: Formatter) -> [Diff] {
    fatalError()
}
