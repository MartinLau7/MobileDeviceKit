//
//  Version.swift
//  MobileDeviceKit
//
//  Created by MartinLau on 15/01/2024.
//

public struct Version: CustomStringConvertible {
    public var major: Int
    public var minor: Int
    public var build: Int
    public var revision: Int

    public static func > (left: Version, right: Version) -> Bool {
        if left.major > right.major {
            if left.minor > right.minor {
                if left.build > right.build {
                    if left.revision > right.revision {
                        return true
                    }
                }
            }
        }
        return false
    }

    public static func >= (left: Version, right: Version) -> Bool {
        if left.major >= right.major {
            if left.minor >= right.minor {
                if left.build >= right.build {
                    if left.revision >= right.revision {
                        return true
                    }
                }
            }
        }
        return false
    }

    public static func < (left: Version, right: Version) -> Bool {
        return !(left > right)
    }

    public static func <= (left: Version, right: Version) -> Bool {
        return !(left >= right)
    }

    public static func == (left: Version, right: Version) -> Bool {
        return left.major == right.major && left.minor == right.minor && left.build == right.build && left.revision == right.revision
    }

    public static func != (left: Version, right: Version) -> Bool {
        return !(left == right)
    }

    ///
    /// @param input
    ///

    /// 轉換代表相當於 Version 物件版本號碼的指定字元唯讀延伸。
    /// - Parameter input: 包含欲轉換版本號碼的字元唯讀延伸,
    ///     - 参数必须如下格式: major.minor[.build[.revision]]
    public static func parse(_ input: String) -> Version? {
        return Version(input)
    }

    public init?(_ verStr: String) {
        guard !verStr.isEmpty else {
            return nil
        }
        let components = verStr.components(separatedBy: ".")
        guard components.count >= 2 else {
            return nil
        }
        major = Int(components[0]) ?? 0
        minor = Int(components[1]) ?? 0

        build = components.count >= 3 ? Int(components[2]) ?? 0 : 0
        revision = components.count > 3 ? (Int(components[3]) ?? 0) : 0
    }

    public var description: String {
        return "\(major).\(minor).\(build).\(revision)"
    }
}
