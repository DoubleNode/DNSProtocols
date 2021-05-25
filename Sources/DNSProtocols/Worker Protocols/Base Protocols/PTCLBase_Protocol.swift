//
//  PTCLBase_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSError
import Foundation

public enum PTCLBaseError: Error
{
    case unknown(_ codeLocation: DNSCodeLocation)
    case invalidParameter(parameter: String, _ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case systemError(error: Error, _ codeLocation: DNSCodeLocation)
}
extension PTCLBaseError: DNSError {
    public static let domain = "BASE"
    public enum Code: Int
    {
        case unknown = 1001
        case invalidParameter = 1002
        case notImplemented = 1003
        case systemError = 1004
    }

    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .invalidParameter(let parameter, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Parameter"] = parameter
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidParameter.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        case .systemError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.systemError.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return NSLocalizedString("BASE-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .invalidParameter(let parameter, _):
            return String(format: NSLocalizedString("BASE-Invalid Parameter: %@", comment: ""),
                          parameter)
                + " (\(Self.domain):\(Self.Code.invalidParameter.rawValue))"
        case .notImplemented:
            return NSLocalizedString("BASE-Not Implemented", comment: "")
                + " (\(Self.domain):\(Self.Code.notImplemented.rawValue))"
        case .systemError(let error, _):
            return String(format: NSLocalizedString("BASE-System Error: %@", comment: ""),
                          error.localizedDescription)
                + " (\(Self.domain):\(Self.Code.systemError.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .systemError(_, let codeLocation),
             .invalidParameter(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}

public enum PTCLCallNextWhen
{
    case always
    case whenError
    case whenNotFound
    case whenUnhandled
}
public enum PTCLCallResult
{
    case completed
    case error
    case notFound
    case unhandled
}
public typealias PTCLCallBlock = () throws -> Void
public typealias PTCLCallResultBlockThrows = (PTCLResultBlock?) throws -> Bool
public typealias PTCLResultBlock = (PTCLCallResult) -> Void

// (currentStep: Int, totalSteps: Int, precentCompleted: Float, statusText: String)
public typealias PTCLProgressBlock = (Int, Int, Float, String) -> Void

public protocol PTCLBase_Protocol: AnyObject
{
    var networkConfigurator: PTCLBase_NetworkConfigurator? { get }

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
}
