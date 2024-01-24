import Foundation
import MobileDeviceKit
import Puppy

final class App {
    let mobileDeviceManager: MobileDeviceManager
    // var puppy: Puppy

    init() {
        mobileDeviceManager = MobileDeviceManager()
        // setup()
        mobileDeviceManager.delegate = self
    }

    deinit {
        mobileDeviceManager.dispose()
    }

    // private func setup() {
    //     LoggingSystem.bootstrap { label in
    //         var handler = PuppyLogHandler(label: label, puppy: self.puppy)
    //         // Set the logging level.
    //         #if DEBUG
    //             handler.logLevel = .debug
    //         #else
    //             handler.logLevel = .trace
    //         #endif

    //         return handler
    //     }
    // }
}

@main
enum Program {
    static func main() throws {
        #if DEBUG
            let logLevel: Logger.Level = .debug
            let consoleLogger: LogLevel = .debug
        #else
            let logLevel: Logger.Level = .info
            let consoleLogger: LogLevel = .info
        #endif

        let console = ConsoleLogger("org.martinlau.MobileDeviceKit.Console", logLevel: consoleLogger, logFormat: ConsoleLogFormatter())
        var puppy = Puppy()
        puppy.add(console)
        LoggingSystem.bootstrap { label in
            var handler = PuppyLogHandler(label: label, puppy: puppy)
            // Set the logging level.
            handler.logLevel = logLevel
            return handler
        }

        _ = App()
        RunLoop.current.run()
    }
}

extension App: MobileDeviceManagerProtocol {
    func deviceRequestingUnlock(device: MobileDeviceKit.Device) {
        print(device)
    }

    func deviceRequestingTrust(device: MobileDeviceKit.Device) {
        print(device)
    }

    func deviceTrustFailed(udid _: String, errorMsg _: String) {}

    func deviceDisconnected(udid _: String) {}

    func deviceConnected(udid _: String) {}
}
