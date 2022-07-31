//
//  SYSPTCLSystemBase.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias SystemBase = SYSPTCLSystemBaseError
}
public enum SYSPTCLSystemBaseError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case duplicateKey(_ codeLocation: DNSCodeLocation)
    case noPermission(permission: String, _ codeLocation: DNSCodeLocation)
    case notFound(_ codeLocation: DNSCodeLocation)
    case notSupported(_ codeLocation: DNSCodeLocation)
    case systemError(error: Error, _ codeLocation: DNSCodeLocation)
    case timeout(_ codeLocation: DNSCodeLocation)

    public static let domain = "SYSBASE"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case duplicateKey = 1003
        case noPermission = 1004
        case notFound = 1005
        case notSupported = 1006
        case systemError = 1007
        case timeout = 1008
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        case .duplicateKey(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.duplicateKey.rawValue,
                                userInfo: userInfo)
        case .noPermission(let permission, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Permission"] = permission
            return NSError.init(domain: Self.domain,
                                code: Self.Code.noPermission.rawValue,
                                userInfo: userInfo)
        case .notFound(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notFound.rawValue,
                                userInfo: userInfo)
        case .notSupported(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notSupported.rawValue,
                                userInfo: userInfo)
        case .systemError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Error"] = error
            return NSError.init(domain: Self.domain,
                                code: Self.Code.systemError.rawValue,
                                userInfo: userInfo)
        case .timeout(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.timeout.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("SYSBASE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("SYSBASE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .duplicateKey:
            return String(format: NSLocalizedString("SYSBASE-Duplicate Key%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.duplicateKey.rawValue))")
        case .noPermission(let permission, _):
            return String(format: NSLocalizedString("SYSBASE-No Permission%@%@", comment: ""),
                          "\(permission as CVarArg)",
                          " (\(Self.domain):\(Self.Code.noPermission.rawValue))")
        case .notFound:
            return String(format: NSLocalizedString("SYSBASE-Not Found%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .notSupported:
            return String(format: NSLocalizedString("SYSBASE-Not Supported%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notSupported.rawValue))")
        case .systemError(let error, _):
            return String(format: NSLocalizedString("SYSBASE-System Error%@%@", comment: ""),
                          "\(error as CVarArg)",
                          " (\(Self.domain):\(Self.Code.systemError.rawValue))")
        case .timeout:
            return String(format: NSLocalizedString("SYSBASE-Timeout%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.timeout.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .duplicateKey(let codeLocation),
             .noPermission(_, let codeLocation),
             .notFound(let codeLocation),
             .notSupported(let codeLocation),
             .systemError(_, let codeLocation),
             .timeout(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public protocol SYSPTCLSystemBase: AnyObject {
    var netConfig: NETPTCLConfig { get }

    func configure()

    func checkOption(_ option: String) -> Bool
    func disableOption(_ option: String)
    func enableOption(_ option: String)
 
    // MARK: - UIWindowSceneDelegate methods
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    func didBecomeActive()
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    func willResignActive()
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    func willEnterForeground()
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    func didEnterBackground()
}
