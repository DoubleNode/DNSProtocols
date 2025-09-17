//
//  WKRPTCLValidation+Error.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSError
import Foundation

public extension DNSError {
    typealias Validation = WKRPTCLValidationError
}
public enum WKRPTCLValidationError: DNSError {
    // Common Errors
    case unknown(_ codeLocation: DNSCodeLocation)
    case notImplemented(_ codeLocation: DNSCodeLocation)
    case notFound(field: String, value: String, _ codeLocation: DNSCodeLocation)
    case invalidParameters(parameters: [String], _ codeLocation: DNSCodeLocation)
    case lowerError(error: Error, _ codeLocation: DNSCodeLocation)
    // Domain-Specific Errors
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
        // Common Errors
        case unknown = 1001
        case notImplemented = 1002
        case notFound = 1003
        case invalidParameters = 1004
        case lowerError = 1005
        // Domain-Specific Errors
        case invalid = 2001
        case noValue = 2002
        case tooHigh = 2003
        case tooLong = 2004
        case tooLow = 2005
        case tooOld = 2006
        case tooShort = 2007
        case tooWeak = 2008
        case tooYoung = 2009
        case required = 2010
    }

    public var nsError: NSError! {
        switch self {
            // Common Errors
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .notImplemented(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notImplemented.rawValue,
                                userInfo: userInfo)
        case .notFound(let field, let value, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["field"] = field
            userInfo["value"] = value
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.notFound.rawValue,
                                userInfo: userInfo)
        case .invalidParameters(let parameters, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            userInfo["Parameters"] = parameters
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalidParameters.rawValue,
                                userInfo: userInfo)
        case .lowerError(let error, let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo["Error"] = error
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.lowerError.rawValue,
                                userInfo: userInfo)
            // Domain-Specific Errors
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
            // Common Errors
        case .unknown:
            return String(format: NSLocalizedString("WKRVALIDATE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("WKRVALIDATE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .notFound(let field, let value, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Not Found%@%@%@", comment: ""),
                          "\(field)", "\(value)",
                          "(\(Self.domain):\(Self.Code.notFound.rawValue))")
        case .invalidParameters(let parameters, _):
            let parametersString = parameters.reduce("") { $0 + ($0.isEmpty ? "" : ", ") + $1 }
            return String(format: NSLocalizedString("WKRVALIDATE-Invalid Parameters%@%@", comment: ""),
                          "\(parametersString)",
                          " (\(Self.domain):\(Self.Code.invalidParameters.rawValue))")
        case .lowerError(let error, _):
            return String(format: NSLocalizedString("WKRVALIDATE-Lower Error%@%@", comment: ""),
                          error.localizedDescription,
                          " (\(Self.domain):\(Self.Code.lowerError.rawValue))")
            // Domain-Specific Errors
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
            // Common Errors
        case .unknown(let codeLocation),
             .notImplemented(let codeLocation),
             .notFound(_, _, let codeLocation),
             .invalidParameters(_, let codeLocation),
             .lowerError(_, let codeLocation),
            // Domain-Specific Errors
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
