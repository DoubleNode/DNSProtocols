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

public protocol WKRPTCLAnalytics: WKRPTCLWorkerBase {
    typealias Events = WKRPTCLAnalyticsEvents

    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAnalytics? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAnalytics,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Auto-Track -
    func doAutoTrack(class: String, method: String) -> WKRPTCLAnalyticsResVoid
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid

    // MARK: - Group -
    func doGroup(groupId: String) -> WKRPTCLAnalyticsResVoid
    func doGroup(groupId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid

    // MARK: - Identify -
    func doIdentify(userId: String) -> WKRPTCLAnalyticsResVoid
    func doIdentify(userId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid

    // MARK: - Screen -
    func doScreen(screenTitle: String) -> WKRPTCLAnalyticsResVoid
    func doScreen(screenTitle: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    
    // MARK: - Track -
    func doTrack(event: WKRPTCLAnalytics.Events) -> WKRPTCLAnalyticsResVoid
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid
}
