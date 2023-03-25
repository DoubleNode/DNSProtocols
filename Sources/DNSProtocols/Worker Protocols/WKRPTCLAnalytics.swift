//
//  WKRPTCLAnalytics.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

// Protocol Return Types
public typealias WKRPTCLAnalyticsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAnalyticsResVoid = Result<WKRPTCLAnalyticsRtnVoid, Error>

public enum WKRPTCLAnalyticsEvents: Int8, CaseIterable, Codable {
    case addToCart
    case appInPlace
    case applyPromoToCart
    case beacon
    case beginCheckout
    case error
    case locationCheck
    case locationEnter
    case locationExit
    case login
    case logout
    case permissionCheck
    case purchase
    case screenClose
    case screenOpen
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

public protocol WKRPTCLAnalytics: WKRPTCLWorkerBase {
    typealias Events = WKRPTCLAnalyticsEvents

    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAnalytics? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAnalytics,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Auto-Track -
    @discardableResult
    func doAutoTrack(class: String, method: String) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid

    // MARK: - Group -
    @discardableResult
    func doGroup(groupId: String) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doGroup(groupId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid

    // MARK: - Identify -
    @discardableResult
    func doIdentify(userId: String) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doIdentify(userId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid

    // MARK: - Screen -
    @discardableResult
    func doScreen(screenTitle: String) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doScreen(screenTitle: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    
    // MARK: - Track -
    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
}
