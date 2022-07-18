//
//  WKRPTCLSupport.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSCoreThreading
import DNSError
import UIKit

public extension DNSError {
    typealias Support = WKRPTCLSupportError
}
public enum WKRPTCLSupportError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case systemError(error: Error, _ codeLocation: DNSCodeLocation)
    case timeout(_ codeLocation: DNSCodeLocation)

    public static let domain = "WKRSUPPORT"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case systemError = 1003
        case timeout = 1004
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
        case .systemError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.systemError.rawValue,
                                userInfo: userInfo)
        case .timeout(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.timeout.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRSUPPORT-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRSUPPORT-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .systemError(let error, _):
            return String(format: NSLocalizedString("WKRSUPPORT-System Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.systemError.rawValue))")
        case .timeout:
            return String(format: NSLocalizedString("WKRSUPPORT-Timeout%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.timeout.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .systemError(_, let codeLocation),
             .timeout(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public struct WKRPTCLSupportAttachment: Hashable {
    public var attachment: AnyHashable?
    public var token: String = ""
    public var image: UIImage
    public init(image: UIImage) {
        self.image = image
    }
    public static func == (lhs: WKRPTCLSupportAttachment, rhs: WKRPTCLSupportAttachment) -> Bool {
        return lhs.image == rhs.image
    }
}

public protocol WKRPTCLSupport: WKRPTCLWorkerBase {
    var callNextWhen: WKRPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLSupport? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLSupport,
                  for callNextWhen: WKRPTCLWorker.Call.NextWhen)

    // MARK: - Business Logic / Single Item CRUD
    func doGetUpdatedCount(with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Int, Error>
    func doPrepare(attachment image: UIImage,
                   with progress: WKRPTCLProgressBlock?) -> AnyPublisher<WKRPTCLSupportAttachment, Error>
    func doSendRequest(subject: String,
                       body: String,
                       tags: [String],
                       attachments: [WKRPTCLSupportAttachment],
                       properties: [String: String],
                       with progress: WKRPTCLProgressBlock?) -> AnyPublisher<Bool, Error>
}