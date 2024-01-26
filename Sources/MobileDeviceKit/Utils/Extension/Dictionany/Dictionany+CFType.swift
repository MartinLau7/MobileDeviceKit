//
//  Dictionany+CFType.swift
//  MobileDeviceKit
//
//  Created by Martin Lau on 31/08/2021.
//

import Foundation

// MARK: - CFDictionany

extension UnmanagedCFDictionary {
    func toDictionany() -> [String: Any]? {
        return takeRetainedValue() as? [String: Any]
    }
}

extension UnmanagedCFPropertyList {
    func toArray() -> [Any]? {
        return takeRetainedValue() as? [Any]
    }

    func toDictionany() -> [String: Any]? {
        return takeRetainedValue() as? [String: Any]
    }
}

extension Dictionary {
    func toCFDictionary() -> CFDictionary {
        return self as CFDictionary
    }

    func toCFPropertyList() -> CFPropertyList {
        return self as CFPropertyList
    }
}
