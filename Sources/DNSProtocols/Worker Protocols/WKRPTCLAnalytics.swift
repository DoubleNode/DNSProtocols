//
//  WKRPTCLAnalytics.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSError
import Foundation

public extension DNSError {
    typealias Analytics = WKRPTCLAnalyticsError
}
public enum WKRPTCLAnalyticsError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRANALYTICS"
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
            return String(format: NSLocalizedString("WKRANALYTICS-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRANALYTICS-Not Implemented%@", comment: ""),
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

public enum WKRPTCLAnalyticsEvents: Int8, CaseIterable, Codable {
    case addToCart
    case appInCenter
    case applyPromoToCart
    case beginCheckout
    case login
    case logout
    case purchase
    case screenView
    case search
    case selectContent
    case selectItem
    case selectPromotion
    case signUp
    case viewCart
    case viewCategory
    case viewItem
    case viewItemList
    case viewPromotion
    case viewSearchResults
    case other
}

public protocol WKRPTCLAnalytics: WKRPTCLWorkerBase
{
    typealias Events = WKRPTCLAnalyticsEvents

    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAnalytics? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAnalytics,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Auto-Track -
    func doAutoTrack(class: String, method: String) throws
    func doAutoTrack(class: String, method: String, properties: [String: Any]) throws
    func doAutoTrack(class: String, method: String, properties: [String: Any], options: [String: Any]) throws

    // MARK: - Group -
    func doGroup(groupId: String) throws
    func doGroup(groupId: String, traits: [String: Any]) throws
    func doGroup(groupId: String, traits: [String: Any], options: [String: Any]) throws

    // MARK: - Identify -
    func doIdentify(userId: String) throws
    func doIdentify(userId: String, traits: [String: Any]) throws
    func doIdentify(userId: String, traits: [String: Any], options: [String: Any]) throws

    // MARK: - Screen -
    func doScreen(screenTitle: String) throws
    func doScreen(screenTitle: String, properties: [String: Any]) throws
    func doScreen(screenTitle: String, properties: [String: Any], options: [String: Any]) throws
    
    // MARK: - Track -
    func doTrack(event: WKRPTCLAnalytics.Events) throws
    func doTrack(event: WKRPTCLAnalytics.Events, properties: [String: Any]) throws
    func doTrack(event: WKRPTCLAnalytics.Events, properties: [String: Any], options: [String: Any]) throws
}
