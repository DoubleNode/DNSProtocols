//
//  WKRPTCLPermissions.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSError
import Foundation

public extension DNSError {
    typealias Permissions = WKRPTCLPermissionsError
}
public enum WKRPTCLPermissionsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRPERMISSIONS"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
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
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRPERMISSIONS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRPERMISSIONS-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public typealias WKRPTCLPermissionsResultArrayPermissionAction = Result<[WKRPTCLPermissionAction], Error>
public typealias WKRPTCLPermissionsResultPermissionAction = Result<WKRPTCLPermissionAction, Error>

public typealias WKRPTCLPermissionsBlockArrayPermissionAction = (WKRPTCLPermissionsResultArrayPermissionAction) -> Void
public typealias WKRPTCLPermissionsBlockPermissionAction = (WKRPTCLPermissionsResultPermissionAction) -> Void

public enum WKRPTCLPermissionsData {
    public enum Action: String, Codable {
        case allowed
        case denied
        case skipped
        case unknown
    }
    public enum Desire: String, Codable {
        case want
        case wouldLike
        case need
        case present
    }
    public enum System: String, Codable {
        case none
        case bluetooth
        case calendar
        case camera
        case contacts
        case locationAlwaysAndWhenInUse
        case locationWhenInUse
        case mediaLibrary
        case microphone
        case motion
        case notification
        case photoLibrary
        case reminders
        case speech
        case tracking

        public var localizedName: String {
            switch self {
            case .none:
                return NSLocalizedString("WKRPTCLPermissionsNameNone", comment: "WKRPTCLPermissionsNameNone")
            case .bluetooth:
                return NSLocalizedString("WKRPTCLPermissionsNameBluetooth", comment: "WKRPTCLPermissionsNameBluetooth")
            case .calendar:
                return NSLocalizedString("WKRPTCLPermissionsNameCalendar", comment: "WKRPTCLPermissionsNameCalendar")
            case .camera:
                return NSLocalizedString("WKRPTCLPermissionsNameCamera", comment: "WKRPTCLPermissionsNameCamera")
            case .contacts:
                return NSLocalizedString("WKRPTCLPermissionsNameContacts", comment: "WKRPTCLPermissionsNameContacts")
            case .locationAlwaysAndWhenInUse:
                return NSLocalizedString("WKRPTCLPermissionsNameLocationAlways", comment: "WKRPTCLPermissionsNameLocationAlways")
            case .locationWhenInUse:
                return NSLocalizedString("WKRPTCLPermissionsNameLocationWhenUse", comment: "WKRPTCLPermissionsNameLocationWhenUse")
            case .mediaLibrary:
                return NSLocalizedString("WKRPTCLPermissionsNameMediaLibrary", comment: "WKRPTCLPermissionsNameMediaLibrary")
            case .microphone:
                return NSLocalizedString("WKRPTCLPermissionsNameMicrophone", comment: "WKRPTCLPermissionsNameMicrophone")
            case .motion:
                return NSLocalizedString("WKRPTCLPermissionsNameMotion", comment: "WKRPTCLPermissionsNameMotion")
            case .notification:
                return NSLocalizedString("WKRPTCLPermissionsNameNotification", comment: "WKRPTCLPermissionsNameNotification")
            case .photoLibrary:
                return NSLocalizedString("WKRPTCLPermissionsNamePhotoLibrary", comment: "WKRPTCLPermissionsNamePhotoLibrary")
            case .reminders:
                return NSLocalizedString("WKRPTCLPermissionsNameReminders", comment: "WKRPTCLPermissionsNameReminders")
            case .speech:
                return NSLocalizedString("WKRPTCLPermissionsNameSpeech", comment: "WKRPTCLPermissionsNameSpeech")
            case .tracking:
                return NSLocalizedString("WKRPTCLPermissionsNameTracking", comment: "WKRPTCLPermissionsNameTracking")
            }
        }
    }
}

public struct WKRPTCLPermissionAction : Codable {
    public var permission: WKRPTCLPermissions.Data.System
    public var action: WKRPTCLPermissions.Data.Action

    public init(_ permission: WKRPTCLPermissions.Data.System,
                _ action: WKRPTCLPermissions.Data.Action) {
        self.permission = permission
        self.action = action
    }
}

public protocol WKRPTCLPermissions: WKRPTCLWorkerBase {
    typealias Data = WKRPTCLPermissionsData
    typealias Action = WKRPTCLPermissionAction
    
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLPermissions? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLPermissions,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                   _ permission: WKRPTCLPermissions.Data.System,
                   with progress: WKRPTCLProgressBlock?,
                   and block: WKRPTCLPermissionsBlockPermissionAction?) throws
    func doRequest(_ desire: WKRPTCLPermissions.Data.Desire,
                   _ permissions: [WKRPTCLPermissions.Data.System],
                   with progress: WKRPTCLProgressBlock?,
                   and block: WKRPTCLPermissionsBlockArrayPermissionAction?) throws
    func doStatus(of permissions: [WKRPTCLPermissions.Data.System],
                  with progress: WKRPTCLProgressBlock?,
                  and block: WKRPTCLPermissionsBlockArrayPermissionAction?) throws
    func doWait(for permission: WKRPTCLPermissions.Data.System,
                with progress: WKRPTCLProgressBlock?,
                and block: WKRPTCLPermissionsBlockPermissionAction?) throws
}
