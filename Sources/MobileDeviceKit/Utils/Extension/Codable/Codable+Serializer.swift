import Foundation

public enum SerializationFormat: UInt {
    case json
    case plist
}

// extension Encodable {}

extension Decodable {
    init(data: Data, format: SerializationFormat = .json) throws {
        if format == .json {
            self = try JSONDecoder().decode(Self.self, from: data)
        } else {
            self = try PropertyListDecoder().decode(Self.self, from: data)
        }
    }

    init(_ dict: [String: Any], format: SerializationFormat = .json) throws {
        if format == .json {
            let data = try JSONSerialization.data(withJSONObject: dict)
            try self.init(data: data, format: format)
        } else {
            let data = try PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options: .zero)
            try self.init(data: data, format: format)
        }
    }
}
