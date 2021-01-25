//
//  PTCLPermissions_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import Foundation

public enum PTCLPermissionsError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case notImplemented(domain: String, file: String, line: String, method: String)
}
extension PTCLPermissionsError: DNSError {
    public static let domain = "PERMISSIONS"
    public enum Code: Int
    {
        case unknown = 1001
        case notImplemented = 1002
    }

    public var nsError: NSError! {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("PERMISSIONS-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .notImplemented:
            return NSLocalizedString("PERMISSIONS-Not Implemented", comment: "")
                + " (\(Self.domain):\(Self.Code.notImplemented.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .notImplemented(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}

// (permissionsActions: [PTCLPermissionAction], error: Error?)
// swiftlint:disable:next type_name
public typealias PTCLPermissionsBlockVoidArrayPTCLPermissionActionError = ([PTCLPermissionAction], DNSError?) -> Void
// (permissionAction: PTCLPermissionAction, error: Error?)
public typealias PTCLPermissionsBlockVoidPTCLPermissionActionError =
    (PTCLPermissionAction, DNSError?) -> Void

public enum PTCLPermissions {
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
    }
    public enum Permission: String, Codable {
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

        var localizedName: String {
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
    var permission: PTCLPermissions.Permission
    var action: PTCLPermissions.Action
}

public protocol PTCLPermissions_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLPermissions_Protocol? { get }

    init()
    init(nextWorker: PTCLPermissions_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doRequest(_ desire: PTCLPermissions.Desire,
                   _ permission: PTCLPermissions.Permission,
                   with progress: PTCLProgressBlock?,
                   and block: @escaping PTCLPermissionsBlockVoidPTCLPermissionActionError) throws
    func doRequest(_ desire: PTCLPermissions.Desire,
                   _ permissions: [PTCLPermissions.Permission],
                   with progress: PTCLProgressBlock?,
                   and block: @escaping PTCLPermissionsBlockVoidArrayPTCLPermissionActionError) throws
    func doStatus(of permissions: [PTCLPermissions.Permission],
                  with progress: PTCLProgressBlock?,
                  and block: @escaping PTCLPermissionsBlockVoidArrayPTCLPermissionActionError) throws
    func doWait(for permission: PTCLPermissions.Permission,
                with progress: PTCLProgressBlock?,
                and block: @escaping PTCLPermissionsBlockVoidPTCLPermissionActionError) throws
}
