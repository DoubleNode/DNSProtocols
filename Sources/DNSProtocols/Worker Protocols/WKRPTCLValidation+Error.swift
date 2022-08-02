//
//  WKRPTCLValidation+Error.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias Validation = WKRPTCLValidationError
}
public enum WKRPTCLValidationError: DNSError {
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case invalid(fieldName: String, _ codeLocation: DNSCodeLocation)
    case noValue(fieldName: String, _ codeLocation: DNSCodeLocation)
    case tooHigh(fieldName: String, _ codeLocation: DNSCodeLocation)
    case tooLong(fieldName: String, _ codeLocation: DNSCodeLocation)
    case tooLow(fieldName: String, _ codeLocation: DNSCodeLocation)
    case tooOld(fieldName: String, _ codeLocation: DNSCodeLocation)
    case tooShort(fieldName: String, _ codeLocation: DNSCodeLocation)
    case tooWeak(fieldName: String, _ codeLocation: DNSCodeLocation)
    case tooYoung(fieldName: String, _ codeLocation: DNSCodeLocation)
    case required(fieldName: String, _ codeLocation: DNSCodeLocation)

    public static let domain = "WKRVALIDATE"
    public enum Code: Int {
        case unknown = 1001
        case notImplemented = 1002
        case invalid = 1003
        case noValue = 1004
        case tooHigh = 1005
        case tooLong = 1006
        case tooLow = 1007
        case tooOld = 1008
        case tooShort = 1009
        case tooWeak = 1010
        case tooYoung = 1011
        case required = 1012
    }

    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.unknown.rawValue, userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.notImplemented.rawValue, userInfo: userInfo)
        case .invalid(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.invalid.rawValue, userInfo: userInfo)
        case .noValue(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.noValue.rawValue, userInfo: userInfo)
        case .tooHigh(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.tooHigh.rawValue, userInfo: userInfo)
        case .tooLong(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.tooLong.rawValue, userInfo: userInfo)
        case .tooLow(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.tooLow.rawValue, userInfo: userInfo)
        case .tooOld(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.tooOld.rawValue, userInfo: userInfo)
        case .tooShort(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.tooShort.rawValue, userInfo: userInfo)
        case .tooWeak(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.tooWeak.rawValue, userInfo: userInfo)
        case .tooYoung(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.tooYoung.rawValue, userInfo: userInfo)
        case .required(let fieldName, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["fieldName"] = fieldName
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain, code: Self.Code.required.rawValue, userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return String(format: NSLocalizedString("WKRVALIDATE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRVALIDATE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .invalid(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Invalid Entry%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.invalid.rawValue))")
        case .noValue(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-No Entry%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.noValue.rawValue))")
        case .tooHigh(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Too High%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.tooHigh.rawValue))")
        case .tooLong(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Too Long%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.tooLong.rawValue))")
        case .tooLow(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Too Low%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.tooLow.rawValue))")
        case .tooOld(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Too Old%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.tooOld.rawValue))")
        case .tooShort(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Too Short%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.tooShort.rawValue))")
        case .tooWeak(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Too Weak%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.tooWeak.rawValue))")
        case .tooYoung(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Too Young%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.tooYoung.rawValue))")
        case .required(let fieldName, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Entry Required%@%@", comment: ""),
                          "\(fieldName)",
                          " (\(Self.domain):\(Self.Code.required.rawValue))")
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .invalid(_, let codeLocation),
             .noValue(_, let codeLocation),
             .tooHigh(_, let codeLocation),
             .tooLong(_, let codeLocation),
             .tooLow(_, let codeLocation),
             .tooOld(_, let codeLocation),
             .tooShort(_, let codeLocation),
             .tooWeak(_, let codeLocation),
             .tooYoung(_, let codeLocation),
             .required(_, let codeLocation):
            return codeLocation.failureReason
        }
    }
}
