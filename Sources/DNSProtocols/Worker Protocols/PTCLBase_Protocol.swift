//
//  PTCLBase_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import Foundation

// (Int currentStep, Int totalSteps, Float precentCompleted, String statusText)
public typealias PTCLProgressBlock = (Int, Int, Float, String) -> Void

public protocol PTCLBase_Protocol: class
{
    func configure()

    func enableOption(option: String)
    func disableOption(option: String)
}
