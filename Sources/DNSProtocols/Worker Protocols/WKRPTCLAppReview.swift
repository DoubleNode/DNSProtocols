//
//  WKRPTCLAppReview.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSError
import Foundation

public extension DNSError {
    typealias AppReview = WKRPTCLAppReviewError
}
public enum WKRPTCLAppReviewError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRAPPREVIEW"
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
            return String(format: NSLocalizedString("WKRAPPREVIEW-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRAPPREVIEW-Not Implemented%@", comment: ""),
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

public protocol WKRPTCLAppReview: WKRPTCLWorkerBase
{
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAppReview? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAppReview,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Properties -
    var launchedCount: UInt { get set }
    var launchedFirstTime: Date { get set }
    var launchedLastTime: Date? { get set }
    var reviewRequestLastTime: Date? { get set }

    var appDidCrashLastRun: Bool { get set }
    var daysBeforeReminding: UInt { get set }
    var daysUntilPrompt: UInt { get set }
    var hoursSinceLastLaunch: UInt { get set }
    var usesFrequency: UInt { get set }
    var usesSinceFirstLaunch: UInt { get set }
    var usesUntilPrompt: UInt { get set }

    // MARK: - Worker Logic (Public) -
    func doReview() throws -> Bool
}
