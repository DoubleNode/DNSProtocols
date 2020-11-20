//
//  PTCLAppReview_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

public enum PTCLAppReviewError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
}
extension PTCLAppReviewError: DNSError {
    public static let domain = "APPREVIEW"
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
            return NSLocalizedString("APPREVIEW-Unknown Error", comment: "")
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

public protocol PTCLAppReview_Protocol: PTCLBase_Protocol
{
    var nextWorker: PTCLAppReview_Protocol? { get }

    init()
    init(nextWorker: PTCLAppReview_Protocol)

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

    // MARK: - Business Logic / Single Item CRUD
    func doReview() throws -> Bool
}
