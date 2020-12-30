//
//  PTCLBase_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import Foundation

public enum PTCLBaseError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case invalidParameter(parameter: String, domain: String, file: String, line: String, method: String)
    case notImplemented(domain: String, file: String, line: String, method: String)
}
extension PTCLBaseError: DNSError {
    public static let domain = "BASE"
    public enum Code: Int
    {
        case unknown = 1001
        case invalidParameter = 1002
        case notImplemented = 1003
    }

    public var nsError: NSError! {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .invalidParameter(let parameter, let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSParameter": parameter,
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let domain, let file, let line, let method):
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("BASE-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .invalidParameter(let parameter, _, _, _, _):
            return String(format: NSLocalizedString("BASE-Invalid Parameter: %@", comment: ""),
                          parameter)
                + " (\(Self.domain):\(Self.Code.invalidParameter.rawValue))"
        case .notImplemented:
            return NSLocalizedString("BASE-Not Implemented", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .invalidParameter(_, let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        case .notImplemented(let domain, let file, let line, let method):
            return "\(domain):\(file):\(line):\(method)"
        }
    }
}

// (currentStep: Int, totalSteps: Int, precentCompleted: Float, statusText: String)
public typealias PTCLProgressBlock = (Int, Int, Float, String) -> Void

public protocol PTCLBase_Protocol: class
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
