import CMobileDeviceKit

public protocol MobileDeviceManagerProtocol {
    func deviceRequestingUnlock(device: Device)

    func deviceRequestingTrust(device: Device)

    func deviceTrustFailed(udid: String, errorMsg: String)

    func deviceDisconnected(udid: String)

    func deviceConnected(udid: String)
}

public final class MobileDeviceManager: ObservableObject {
    private var subscribeNotification: AMDeviceNotificationRef?
    private var subscribed: Bool = false

    public internal(set) var connectedDevices: [Device] = []

    public var delegate: MobileDeviceManagerProtocol?

    private static var _shareInstance: MobileDeviceManager?
    public static let `default`: MobileDeviceManager = {
        guard let _shareInstance else {
            _shareInstance = MobileDeviceManager()
            return _shareInstance!
        }
        return _shareInstance
    }()

    deinit {
        #if DEBUG
            print("deint")
        #endif
    }

    // MARK: - Private

    private init() {
        startListeningDevicesConnection()
    }

    private func notifyDeviceRequestingUnlock(device: Device) {
        delegate?.deviceRequestingUnlock(device: device)
    }

    private func notifyDeviceRequestingTrust(device: Device) {
        delegate?.deviceRequestingTrust(device: device)
    }

    private func notifyDeviceTrustFailed(_ udid: String, errorMsg: String = "使用者拒绝信任请求, 请中断并重新连接你的设备.") {
        delegate?.deviceTrustFailed(udid: udid, errorMsg: errorMsg)
    }

    private func notifyDeviceConnected(_ uuid: String) {
        delegate?.deviceConnected(udid: uuid)
    }

    private func notifyDeviceDisconnected(_ uuid: String) {
        delegate?.deviceDisconnected(udid: uuid)
    }

    /// 是否iOS7 之前的版本
    private func isBefore7Version(device: AMDeviceRef) -> Bool {
        if let value = try? copyValueFromDevice(device, domain: nil, key: "ProductVersion", basePaired: false) as? String {
            if let productVersion = Version(value), productVersion.major >= 7 {
                return false
            }
            return true
        }
        return false
    }

    private func containsDevice(with uniqueDeviceId: String) -> Bool {
        return connectedDevices.contains { $0.deviceInformation?.uniqueDeviceId == uniqueDeviceId }
    }

    private func disconnectAllDevices() {
        // for device in connectedDevices {
        //     device.dispose()
        // }
        connectedDevices.removeAll()
    }

    private func notify(callbackInfo: AMDeviceNotificationInfo) {
        if let deviceRef = callbackInfo.Device {
            guard !isBefore7Version(device: deviceRef) else { return }
            let uniqueDeviceId = copyDeviceIdentifier(deviceRef) as String

            switch callbackInfo.Action {
            case kAMDeviceAttached:
                guard !containsDevice(with: uniqueDeviceId) else {
                    return
                }
                let device = Device(deviceRef)
                print("当前连接设备: \(device.uniqueDeviceId) \(device.isPaired ? "已配对" : "未配对信任")")
                connectedDevices.append(device)
                notifyDeviceConnected(device.uniqueDeviceId)
            case kAMDeviceDetached:
                print("当前断开设备: \(uniqueDeviceId)")
                disConnect(with: uniqueDeviceId)
            case kAMDevicePaired:
                if let appleDevice = connectedDevices.first(where: { $0.deviceInformation?.uniqueDeviceId == uniqueDeviceId }) {
                    do {
                        if !appleDevice.isPaired {
                            // try appleDevice.try2PairDevice()
                        }
                        // try? appleDevice.try2ConnectDevice()
                        // notifyDeviceConnected(appleDevice.deviceInformation.uniqueDeviceId)
                    } catch {
                        print("connecting error: ", error.localizedDescription)
                    }
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
        if let notification = subscribeNotification {
            subscribed = false
            return AMDeviceNotificationUnsubscribe(notification) == 0
        }
        return true
    }

    // MARK: - Public

    public func tryTrustDevice(_: Device) {
        // do {
        //     try device.try2PairDevice()
        // } catch let err as MobileDeviceError {
        //     var errorMsg = err.localizedDescription
        //     if err == .userDeniedPairing {
        //         errorMsg = "使用者拒绝信任请求, 请中断并重新连接你的设备."
        //     }
        //     self.notifyDeviceTrustFailed(device.deviceInformation.uniqueDeviceId, errorMsg: errorMsg)
        // } catch {
        //     #if DEBUG
        //         print("tryTrustDevice Failed: ", error)
        //     #endif
        //     notifyDeviceTrustFailed(device.deviceInformation.uniqueDeviceId, errorMsg: error.localizedDescription)
        // }
    }

    public func tryWatchTrustDeviceAsync(_: Device, timeout _: TimeInterval) {
        // DispatchQueue.global().async {
        //     let timeoutDate = Date().addingTimeInterval(timeout)
        //     var errorMessage = "Trust Timeout."
        //     while !device.isPaired && !device.deniedTrust {
        // do {
        //     try device.try2PairDevice()
        // } catch let err as MobileDeviceError {
        //     errorMessage = err.localizedDescription
        //     if err == .userDeniedPairing {
        //         errorMessage = "使用者拒绝信任请求, 请中断并重新连接你的设备."
        //         break
        //     }
        //     if err == .pairingDialogResponsePending || err == .passwordProtected {
        //         if Date() >= timeoutDate {
        //             errorMessage = "Trust Timeout."
        //             break
        //         }
        //     }
        //     sleep(1)
        // } catch {
        //     errorMessage = error.localizedDescription
        //     sleep(1)
        // }
        // }
        // DispatchQueue.main.async {
        //     if device.deniedTrust {
        //         self.notifyDeviceTrustFailed(device.deviceInformation.uniqueDeviceId, errorMsg: "使用者拒绝信任请求, 请中断并重新连接你的设备.")
        //         return
        //     }
        //     if !device.isPaired {
        //         self.notifyDeviceTrustFailed(device.deviceInformation.uniqueDeviceId, errorMsg: errorMessage)
        //     }
        // }
        // }
    }

    public func disConnect(with uniqueDeviceId: String) {
        connectedDevices.removeAll {
            if $0.deviceInformation?.uniqueDeviceId == uniqueDeviceId {
                notifyDeviceDisconnected(uniqueDeviceId)
                return true
            }
            return false
        }
    }
}
