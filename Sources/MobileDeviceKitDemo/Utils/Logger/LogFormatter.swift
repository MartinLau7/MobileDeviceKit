import Foundation
import Puppy

struct ConsoleLogFormatter: LogFormattable {
    func formatMessage(_ level: LogLevel, message: String, tag _: String, function: String,
                       file: String, line: UInt, swiftLogInfo _: [String: String],
                       label _: String, date: Date, threadID: UInt64) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "zh_Hans")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMMdd HH:mm:ss")
        let date = dateFormatter.string(from: date)
        return "[\u{001B}[1;34m\(level) ⌘ \(date)\u{001B}[0m] [\(threadID)] \u{001B}[1;4;93m\(file):\(line) \(function)\u{001B}[0m\n\(message)"
    }
}

struct FileRotationLogFormatter: LogFormattable {
    func formatMessage(_ level: LogLevel, message: String, tag _: String, function: String,
                       file: String, line: UInt, swiftLogInfo _: [String: String],
                       label _: String, date _: Date, threadID _: UInt64) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "zh_Hans")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMMdd HH:mm:ss")
        let date = dateFormatter.string(from: Date())
        return "[\(level) ⌘ \(date)] \(file)#L-\(line) \(function)\n\(message)"
    }
}
