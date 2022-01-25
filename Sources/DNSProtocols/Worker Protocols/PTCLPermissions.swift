//
//  PTCLPermissions_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSError
import Foundation

public extension DNSError {
    typealias Permissions = PTCLPermissionsError
}
public enum PTCLPermissionsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "PERMISSIONS"
    public enum Code: Int
    {
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
            return String(format: NSLocalizedString("PERMISSIONS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("PERMISSIONS-Not Implemented%@", comment: ""),
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

public typealias PTCLPermissionsResultArrayPermissionAction =
    Result<[PTCLPermissionAction], Error>
public typealias PTCLPermissionsResultPermissionAction =
    Result<PTCLPermissionAction, Error>

public typealias PTCLPermissionsBlockVoidArrayPermissionAction =
    (PTCLPermissionsResultArrayPermissionAction) -> Void
public typealias PTCLPermissionsBlockVoidPermissionAction =
    (PTCLPermissionsResultPermissionAction) -> Void

public enum PTCLPermissionsData {
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
                return NSLocalizedString("PTCLPermissionsNameNone", comment: "PTCLPermissionsNameNone")
            case .bluetooth:
                return NSLocalizedString("PTCLPermissionsNameBluetooth", comment: "PTCLPermissionsNameBluetooth")
            case .calendar:
                return NSLocalizedString("PTCLPermissionsNameCalendar", comment: "PTCLPermissionsNameCalendar")
            case .camera:
                return NSLocalizedString("PTCLPermissionsNameCamera", comment: "PTCLPermissionsNameCamera")
            case .contacts:
                return NSLocalizedString("PTCLPermissionsNameContacts", comment: "PTCLPermissionsNameContacts")
            case .locationAlwaysAndWhenInUse:
                return NSLocalizedString("PTCLPermissionsNameLocationAlways", comment: "PTCLPermissionsNameLocationAlways")
            case .locationWhenInUse:
                return NSLocalizedString("PTCLPermissionsNameLocationWhenUse", comment: "PTCLPermissionsNameLocationWhenUse")
            case .mediaLibrary:
                return NSLocalizedString("PTCLPermissionsNameMediaLibrary", comment: "PTCLPermissionsNameMediaLibrary")
            case .microphone:
                return NSLocalizedString("PTCLPermissionsNameMicrophone", comment: "PTCLPermissionsNameMicrophone")
            case .motion:
                return NSLocalizedString("PTCLPermissionsNameMotion", comment: "PTCLPermissionsNameMotion")
            case .notification:
                return NSLocalizedString("PTCLPermissionsNameNotification", comment: "PTCLPermissionsNameNotification")
            case .photoLibrary:
                return NSLocalizedString("PTCLPermissionsNamePhotoLibrary", comment: "PTCLPermissionsNamePhotoLibrary")
            case .reminders:
                return NSLocalizedString("PTCLPermissionsNameReminders", comment: "PTCLPermissionsNameReminders")
            case .speech:
                return NSLocalizedString("PTCLPermissionsNameSpeech", comment: "PTCLPermissionsNameSpeech")
            case .tracking:
                return NSLocalizedString("PTCLPermissionsNameTracking", comment: "PTCLPermissionsNameTracking")
            }
        }
    }
}

public struct PTCLPermissionAction : Codable {
    public var permission: PTCLPermissions.Data.System
    public var action: PTCLPermissions.Data.Action

    public init(_ permission: PTCLPermissions.Data.System,
                _ action: PTCLPermissions.Data.Action) {
        self.permission = permission
        self.action = action
    }
}

public protocol PTCLPermissions: PTCLProtocolBase {
    typealias Data = PTCLPermissionsData
    typealias Action = PTCLPermissionAction
    
    var callNextWhen: PTCLProtocol.Call.NextWhen { get }
    var nextWorker: PTCLPermissions? { get }
    var systemsWorker: PTCLSystems? { get }

    init()
    func register(nextWorker: PTCLPermissions,
                  for callNextWhen: PTCLProtocol.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD

    func doRequest(_ desire: PTCLPermissions.Data.Desire,
                   _ permission: PTCLPermissions.Data.System,
                   with progress: PTCLProgressBlock?,
                   and block: PTCLPermissionsBlockVoidPermissionAction?) throws
    func doRequest(_ desire: PTCLPermissions.Data.Desire,
                   _ permissions: [PTCLPermissions.Data.System],
                   with progress: PTCLProgressBlock?,
                   and block: PTCLPermissionsBlockVoidArrayPermissionAction?) throws
    func doStatus(of permissions: [PTCLPermissions.Data.System],
                  with progress: PTCLProgressBlock?,
                  and block: PTCLPermissionsBlockVoidArrayPermissionAction?) throws
    func doWait(for permission: PTCLPermissions.Data.System,
                with progress: PTCLProgressBlock?,
                and block: PTCLPermissionsBlockVoidPermissionAction?) throws
}
