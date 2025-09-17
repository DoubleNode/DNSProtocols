//
//  WKRPTCLAppReview.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import Foundation

// Protocol Return Types
public typealias WKRPTCLAppReviewRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAppReviewResVoid = Result<WKRPTCLAppReviewRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLAppReviewBlkVoid = (WKRPTCLAppReviewResVoid) -> Void

public protocol WKRPTCLAppReview: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }

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
    func doReview() -> WKRPTCLAppReviewResVoid
    func doReview(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAppReviewBlkVoid?)
    func doReview(using parameters: DNSDataDictionary, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLAppReviewBlkVoid?)
    
    // MARK: - Worker Logic (Shortcuts) -
    func doReview(and block: WKRPTCLAppReviewBlkVoid?)
    func doReview(using parameters: DNSDataDictionary, and block: WKRPTCLAppReviewBlkVoid?)
}
