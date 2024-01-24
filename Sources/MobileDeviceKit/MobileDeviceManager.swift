import CMobileDeviceKit
import Logging

public protocol MobileDeviceConnectionDelegate {
    func deviceDisconnected(udid: String)

    func deviceConnected(udid: String)
}

public final class MobileDeviceManager: ObservableObject {
    private var subscribeNotification: AMDeviceNotificationRef?
    private var subscribed: Bool = false

    public internal(set) var connectedDevices: [Device] = []

    public var delegate: MobileDeviceConnectionDelegate?

    public var logger: Logger

    deinit {
        #if DEBUG
            print("deint")
        #endif
    }

    public init(logger: Logger = .init(label: "org.martinlau.MobileDeviceKit.MobileDeviceManager")) {
        self.logger = logger
        startListeningDevicesConnection()
    }

    // MARK: - Private

    private func notifyDeviceConnected(_ uuid: String) {
        delegate?.deviceConnected(udid: uuid)
    }

    private func notifyDeviceDisconnected(_ uuid: String) {
        delegate?.deviceDisconnected(udid: uuid)
    }

    /// 是否iOS7 之前的版本
    private func isDeviceBefore7Version(_ device: AMDeviceRef) -> Bool {
        if let value = try? copyValueFromDevice(device, domain: nil, key: "ProductVersion", basePaired: false) as? String {
            if let productVersion = Version(value), productVersion.major >= 7 {
                return false
            }
            return true
        }
        return false
    }

    private func containsDevice(with uniqueDeviceId: String) -> Bool {
        return connectedDevices.contains { $0.uniqueDeviceId == uniqueDeviceId }
    }

    private func disconnectAllDevices() {
        for device in connectedDevices {
            device.dispose()
        }
        connectedDevices.removeAll()
    }

    private func notify(callbackInfo: AMDeviceNotificationInfo) {
        if let deviceRef = callbackInfo.Device {
            guard getDeviceInterfaceType(deviceRef) == .wired else { return }
            guard !isDeviceBefore7Version(deviceRef) else { return }
            let uniqueDeviceId = copyDeviceIdentifier(deviceRef) as String
            logger.debug("触发事件装置 ID: \(uniqueDeviceId)")

            switch callbackInfo.Action {
            case kAMDeviceAttached:
                guard !containsDevice(with: uniqueDeviceId) else {
                    return
                }
                let device = Device(deviceRef, logger: logger)
                logger.debug("attached to device: \(device.uniqueDeviceId) - (\(device.isPaired ? "paried" : "unpair"))")

                connectedDevices.append(device)
                notifyDeviceConnected(device.uniqueDeviceId)
            case kAMDeviceDetached:
                logger.debug("当前断开设备: \(uniqueDeviceId)")
                disConnect(with: uniqueDeviceId)
            case kAMDevicePaired:
                if let device = connectedDevices.first(where: { $0.uniqueDeviceId == uniqueDeviceId }) {
                    device.requestDevicePairingStatus()
                    logger.debug("attached to device: \(device.uniqueDeviceId) - (\(device.isPaired ? "paried" : "unpair"))")
                }
            case kAMDeviceNotificationStopped:
                print("设备订阅被取消或异常")
            default:
                break
            }
        }
    }

    /// 監聽裝置連線
    @discardableResult private func startListeningDevicesConnection() -> Bool {
        if !subscribed {
            logger.debug("startListeningDevices")
            let selfPtr = Marshal.toUnretained(self)
            // 只监听 USB 连接装置
            if AMDeviceNotificationSubscribe({ notificationInfo, arg in
                if let info = notificationInfo {
                    if let arg = arg {
                        let manager: MobileDeviceManager = Marshal.toUnretainedReference(arg)
                        manager.notify(callbackInfo: info.pointee)
                    }
                }
            }, 0, kAMDeviceInterfaceConnectionTypeDirect, selfPtr, &subscribeNotification) == 0 {
                subscribed = true
                return true
            }
        }
        return subscribed
    }

    /// 取消監聽裝置連線
    @discardableResult private func stopListeningDeviceConnection() -> Bool {
        if let subscribeNotification {
            subscribed = false
            return AMDeviceNotificationUnsubscribe(subscribeNotification) == 0
        }
        return true
    }

    // MARK: - Public

    public func dispose() {
        stopListeningDeviceConnection()
        disconnectAllDevices()
    }

    public func disConnect(with uniqueDeviceId: String) {
        connectedDevices.removeAll {
            if $0.uniqueDeviceId == uniqueDeviceId {
                notifyDeviceDisconnected(uniqueDeviceId)
                return true
            }
            return false
        }
    }
}
