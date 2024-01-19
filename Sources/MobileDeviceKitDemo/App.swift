import Foundation
import MobileDeviceKit

final class App {
    init() {
        MobileDeviceManager.default.delegate = self
    }
}

@main
enum Program {
    static func main() throws {
        let app = App()

        RunLoop.current.run()
        print("1111")
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
