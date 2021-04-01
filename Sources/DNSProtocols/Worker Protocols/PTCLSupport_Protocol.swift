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
import UIKit

public enum PTCLSupportError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case systemError(error: Error, _ codeLocation: DNSCodeLocation)
}
extension PTCLSupportError: DNSError {
    public static let domain = "SUPPORT"
    public enum Code: Int
    {
        case unknown = 1001
        case notImplemented = 1002
        case systemError = 1003
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
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("SUPPORT-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("SUPPORT-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .systemError(let error, _):
            return String(format: NSLocalizedString("SUPPORT-System Error: %@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.systemError.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .systemError(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public struct PTCLSupportAttachment {
    var attachment: Any?
    var token: String
    var image: UIImage
}
public protocol PTCLSupport_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLSupport_Protocol? { get }

    init()
    init(nextWorker: PTCLSupport_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doGetUpdatedCount(with progress: PTCLProgressBlock?) -> AnyPublisher<Int, Error>
    func doPrepare(attachment image: UIImage,
                   with progress: PTCLProgressBlock?) -> AnyPublisher<PTCLSupportAttachment, Error>
    func doSendRequest(subject: String,
                       body: String,
                       tags: [String],
                       attachments: [PTCLSupportAttachment],
                       properties: [String: String],
                       with progress: PTCLProgressBlock?) -> AnyPublisher<Bool, Error>
}
