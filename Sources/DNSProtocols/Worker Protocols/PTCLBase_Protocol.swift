//
//  PTCLBase_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

// (currentStep: Int, totalSteps: Int, precentCompleted: Float, statusText: String)
public typealias PTCLProgressBlock = (Int, Int, Float, String) -> Void

public protocol PTCLBase_Protocol: class
{
    func configure()

    func enableOption(option: String)
    func disableOption(option: String)
    
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
}
