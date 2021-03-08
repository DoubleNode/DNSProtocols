//
//  PTCLSupport_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSError
import Foundation

public enum PTCLSupportError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
}
extension PTCLSupportError: DNSError {
    public static let domain = "SUPPORT"
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
            return NSLocalizedString("SUPPORT-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .notImplemented:
            return NSLocalizedString("SUPPORT-Not Implemented", comment: "")
                + " (\(Self.domain):\(Self.Code.notImplemented.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation):
            return codeLocation.failureReason
        case .notImplemented(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// (count: Int, error: Error?)
public typealias PTCLSupportBlockVoidIntError = (Int, Error?) -> Void

public protocol PTCLSupport_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLSupport_Protocol? { get }

    init()
    init(nextWorker: PTCLSupport_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doGetUpdatedCount(with progress: PTCLProgressBlock?) -> AnyPublisher<Int, Error>
}
