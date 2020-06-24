//
//  PTCLAppReview_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import Foundation

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
    var daysUntilPrompt: Int { get set }
    var usesUntilPrompt: Int { get set }
    var daysBeforeReminding: Int { get set }

    // MARK: - Business Logic / Single Item CRUD
    func doReview() throws -> Bool
}
