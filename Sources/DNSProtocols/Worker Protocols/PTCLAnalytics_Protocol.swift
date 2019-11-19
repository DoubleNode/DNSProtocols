//
//  PTCLAnalytics_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

public protocol PTCLAnalytics_Protocol: PTCLBase_Protocol
{
    var nextWorker: PTCLAnalytics_Protocol? { get }
    
    init()
    init(nextWorker: PTCLAnalytics_Protocol)

    // MARK: - Identify
    func doIdentify(userId: String) throws
    func doIdentify(userId: String, traits: [String: Any]?) throws
    func doIdentify(userId: String, traits: [String: Any]?, options: [String: Any]?) throws

    // MARK: - Track
    func doTrack(event: String) throws
    func doTrack(event: String, properties: [String: Any]?) throws
    func doTrack(event: String, properties: [String: Any]?, options: [String: Any]?) throws

    // MARK: - Screen
    func doScreen(screenTitle: String) throws
    func doScreen(screenTitle: String, properties: [String: Any]?) throws
    func doScreen(screenTitle: String, properties: [String: Any]?, options: [String: Any]?) throws

    // MARK: - Group
    func doGroup(groupId: String) throws
    func doGroup(groupId: String, traits: [String: Any]?) throws
    func doGroup(groupId: String, traits: [String: Any]?, options: [String: Any]?) throws
}
