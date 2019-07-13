//
//  Formatter.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/13.
//

import Foundation

public protocol Formatter {
    func format(lhs: String, rhs: String) -> String
}

public struct DiffingFormatter: Formatter {
    public init() { }
    public func format(lhs: String, rhs: String) -> String {
        return ""
    }
}


