//
//  PTCLAnalytics_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import Foundation

public enum PTCLAnalyticsError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
}
extension PTCLAnalyticsError: DNSError {
    public static let domain = "ANALYTICS"
    public enum Code: Int
    {
        case unknown = 1001
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
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("ANALYTICS-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}

public protocol PTCLAnalytics_Protocol: PTCLBase_Protocol
{
    var nextWorker: PTCLAnalytics_Protocol? { get }

    init()
    init(nextWorker: PTCLAnalytics_Protocol)

    // MARK: - Auto-Track -
    func doAutoTrack(class: String, method: String) throws
    func doAutoTrack(class: String, method: String, properties: [String: Any]?) throws
    func doAutoTrack(class: String, method: String, properties: [String: Any]?, options: [String: Any]?) throws

    // MARK: - Identify -
    func doIdentify(userId: String) throws
    func doIdentify(userId: String, traits: [String: Any]?) throws
    func doIdentify(userId: String, traits: [String: Any]?, options: [String: Any]?) throws

    // MARK: - Track -
    func doTrack(event: String) throws
    func doTrack(event: String, properties: [String: Any]?) throws
    func doTrack(event: String, properties: [String: Any]?, options: [String: Any]?) throws

    // MARK: - Screen -
    func doScreen(screenTitle: String) throws
    func doScreen(screenTitle: String, properties: [String: Any]?) throws
    func doScreen(screenTitle: String, properties: [String: Any]?, options: [String: Any]?) throws

    // MARK: - Group -
    func doGroup(groupId: String) throws
    func doGroup(groupId: String, traits: [String: Any]?) throws
    func doGroup(groupId: String, traits: [String: Any]?, options: [String: Any]?) throws
}
