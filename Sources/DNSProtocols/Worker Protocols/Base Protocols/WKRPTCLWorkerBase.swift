//
//  WKRPTCLWorkerBase.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLWorkerBaseRtnAAnalyticsData = [DAOAnalyticsData]

// Protocol Result Types
public typealias WKRPTCLWorkerBaseResAAnalyticsData = Result<WKRPTCLWorkerBaseRtnAAnalyticsData, Error>

// Protocol Block Types
public typealias WKRPTCLWorkerBaseBlkAAnalyticsData = (WKRPTCLWorkerBaseResAAnalyticsData) -> Void

public protocol WKRPTCLWorkerBase: DNSPTCLWorker {
    static var xlt: DNSDataTranslation { get }
    
    var netConfig: NETPTCLConfig { get set }
    var netRouter: NETPTCLRouter { get set }
    
    var wkrSystems: WKRPTCLSystems? { get }
    
    func configure()
    
    func checkOption(_ option: String) -> Bool
    func disableOption(_ option: String)
    func enableOption(_ option: String)
    
    // MARK: - UIWindowSceneDelegate methods
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    func didBecomeActive()
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    func willResignActive()
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
    func willEnterForeground()
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    func didEnterBackground()
    
    // MARK: - Worker Logic (Public) -
    func doAnalytics(for object: DAOBaseObject,
                     using data: DNSDataDictionary,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLWorkerBaseBlkAAnalyticsData?)
    
    // MARK: - Worker Logic (Shortcuts) -
    func doAnalytics(for object: DAOBaseObject,
                     using data: DNSDataDictionary,
                     and block: WKRPTCLWorkerBaseBlkAAnalyticsData?)
}
