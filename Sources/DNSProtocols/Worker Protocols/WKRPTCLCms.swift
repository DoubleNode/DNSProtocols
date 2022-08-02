//
//  WKRPTCLCms.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

// Protocol Return Types
public typealias WKRPTCLCmsRtnAAny = [Any]

// Protocol Result Types
public typealias WKRPTCLCmsResAAny = Result<WKRPTCLCmsRtnAAny, Error>

// Protocol Block Types
public typealias WKRPTCLCmsBlkAAny = (WKRPTCLCmsResAAny) -> Void

public protocol WKRPTCLCms: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLCms? { get }
    var systemsWorker: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLCms,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoad(for group: String,
                with progress: DNSPTCLProgressBlock?,
                and block: WKRPTCLCmsBlkAAny?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoad(for group: String,
                with block: WKRPTCLCmsBlkAAny?)
}
