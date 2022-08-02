//
//  WKRPTCLPermissions+Data.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

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
