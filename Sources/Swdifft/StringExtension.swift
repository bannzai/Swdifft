//
//  StringExtension.swift
//  Swdifft
//
//  Created by Yudai Hirose on 2019/07/16.
//

import Foundation

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
