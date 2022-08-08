//
//  WKRPTCLSupport.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import UIKit

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

// Protocol Return Types
public typealias WKRPTCLSupportRtnAttach = WKRPTCLSupportAttachment
public typealias WKRPTCLSupportRtnInt = Int
public typealias WKRPTCLSupportRtnVoid = Void

// Protocol Publisher Types
public typealias WKRPTCLSupportPubAttach = AnyPublisher<WKRPTCLSupportRtnAttach, Error>
public typealias WKRPTCLSupportPubInt = AnyPublisher<WKRPTCLSupportRtnInt, Error>
public typealias WKRPTCLSupportPubVoid = AnyPublisher<WKRPTCLSupportRtnVoid, Error>

// Protocol Future Types
public typealias WKRPTCLSupportFutAttach = Future<WKRPTCLSupportRtnAttach, Error>
public typealias WKRPTCLSupportFutInt = Future<WKRPTCLSupportRtnInt, Error>
public typealias WKRPTCLSupportFutVoid = Future<WKRPTCLSupportRtnVoid, Error>

public protocol WKRPTCLSupport: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLSupport? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLSupport,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doGetUpdatedCount(with progress: DNSPTCLProgressBlock?) -> WKRPTCLSupportPubInt
    func doPrepare(attachment image: UIImage,
                   with progress: DNSPTCLProgressBlock?) -> WKRPTCLSupportPubAttach
    func doSendRequest(subject: String,
                       body: String,
                       tags: [String],
                       attachments: [WKRPTCLSupportAttachment],
                       properties: [String: String],
                       with progress: DNSPTCLProgressBlock?) -> WKRPTCLSupportPubVoid

    // MARK: - Worker Logic (Shortcuts) -
    func doGetUpdatedCount() -> WKRPTCLSupportPubInt
    func doPrepare(attachment image: UIImage) -> WKRPTCLSupportPubAttach
    func doSendRequest(subject: String,
                       body: String,
                       tags: [String],
                       attachments: [WKRPTCLSupportAttachment],
                       properties: [String: String]) -> WKRPTCLSupportPubVoid
}
