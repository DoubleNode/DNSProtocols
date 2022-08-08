//
//  WKRPTCLAppReview.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

// Protocol Return Types
public typealias WKRPTCLAppReviewRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAppReviewResVoid = Result<WKRPTCLAppReviewRtnVoid, Error>

public protocol WKRPTCLAppReview: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAppReview? { get }
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
}
