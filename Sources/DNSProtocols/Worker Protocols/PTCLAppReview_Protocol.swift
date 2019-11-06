//
//  PTCLAppReview_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

public protocol PTCLAppReview_Protocol: PTCLBase_Protocol
{
    var launchedCount: UInt { get set }
    var launchedFirstTime: Date { get set }
    var launchedLastTime: Date? { get set }
    var reviewRequestLastTime: Date? { get set }

    var appDidCrashLastRun: Bool { get set }
    var daysUntilPrompt: Int { get set }
    var usesUntilPrompt: Int { get set }
    var daysBeforeReminding: Int { get set }

    init()
    init(nextAppReviewWorker: PTCLAppReview_Protocol)

    func nextAppReviewWorker() -> PTCLAppReview_Protocol?

    // MARK: - Business Logic / Single Item CRUD
    func doReview() throws -> Bool
}
