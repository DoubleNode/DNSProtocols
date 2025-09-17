//
//  WKRPTCLCache.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
#if canImport(UIKit)
import UIKit
#endif

// Protocol Return Types
public typealias WKRPTCLCacheRtnAny = Any
#if canImport(UIKit)
public typealias WKRPTCLCacheRtnImage = UIImage
#else
public typealias WKRPTCLCacheRtnImage = Any
#endif
public typealias WKRPTCLCacheRtnString = String
public typealias WKRPTCLCacheRtnVoid = Void

// Protocol Publisher Types
public typealias WKRPTCLCachePubAny = AnyPublisher<WKRPTCLCacheRtnAny, Error>
public typealias WKRPTCLCachePubImage = AnyPublisher<WKRPTCLCacheRtnImage, Error>
public typealias WKRPTCLCachePubString = AnyPublisher<WKRPTCLCacheRtnString, Error>
public typealias WKRPTCLCachePubVoid = AnyPublisher<WKRPTCLCacheRtnVoid, Error>

// Protocol Future Types
public typealias WKRPTCLCacheFutAny = Future<WKRPTCLCacheRtnAny, Error>
public typealias WKRPTCLCacheFutImage = Future<WKRPTCLCacheRtnImage, Error>
public typealias WKRPTCLCacheFutString = Future<WKRPTCLCacheRtnString, Error>
public typealias WKRPTCLCacheFutVoid = Future<WKRPTCLCacheRtnVoid, Error>

public protocol WKRPTCLCache: WKRPTCLWorkerBase
{
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLCache,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doDeleteObject(for id: String,
                        with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubVoid
    func doLoadImage(from url: NSURL,
                     for id: String,
                     with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubImage
    func doReadObject(for id: String,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny
    func doReadString(for id: String,
                      with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubString
    func doUpdate(object: Any,
                  for id: String,
                  with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny

    // MARK: - Worker Logic (Shortcuts) -
    func doDeleteObject(for id: String) -> WKRPTCLCachePubVoid
    func doLoadImage(from url: NSURL,
                     for id: String) -> WKRPTCLCachePubImage
    func doReadObject(for id: String) -> WKRPTCLCachePubAny
    func doReadString(for id: String) -> WKRPTCLCachePubString
    func doUpdate(object: Any,
                  for id: String) -> WKRPTCLCachePubAny
}
