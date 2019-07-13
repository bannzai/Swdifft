//
//  Diff.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/13.
//

import Foundation

public struct Diff {
//    public let range: Range<Int>
//    public let text: String
    
    public let lhs: String
    public let rhs: String
    
    public init(
        lhs: String,
        rhs: String
        ) {
        self.lhs = lhs
        self.rhs = rhs
    }
}
