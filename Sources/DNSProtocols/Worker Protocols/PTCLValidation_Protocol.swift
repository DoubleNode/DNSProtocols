//
//  PTCLValidation_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCoreThreading
import DNSDataObjects
import DNSError
import Foundation

public enum PTCLValidationError: Error
{
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
}
extension PTCLValidationError: DNSError {
    public static let domain = "VALIDATE"
    public enum Code: Int
    {
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
            return String(format: NSLocalizedString("VALIDATE-Unknown Error%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.unknown.rawValue))")
        case .notImplemented:
            return String(format: NSLocalizedString("VALIDATE-Not Implemented%@", comment: ""),
                          " (\(Self.domain):\(Self.Code.notImplemented.rawValue))")
        case .invalid(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Invalid Entry: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.invalid.rawValue))")
        case .noValue(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-No Entry: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.noValue.rawValue))")
        case .tooHigh(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Too High: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.tooHigh.rawValue))")
        case .tooLong(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Too Long: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.tooLong.rawValue))")
        case .tooLow(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Too Low: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.tooLow.rawValue))")
        case .tooOld(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Too Old: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.tooOld.rawValue))")
        case .tooShort(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Too Short: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.tooShort.rawValue))")
        case .tooWeak(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Too Weak: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.tooWeak.rawValue))")
        case .tooYoung(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Too Young: %@%@", comment: ""),
                          fieldName,
                          " (\(Self.domain):\(Self.Code.tooYoung.rawValue))")
        case .required(let fieldName, _):
            return String(format: NSLocalizedString("VALIDATE-Entry Required: %@%@", comment: ""),
                          fieldName,
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

public enum PTCLValidationRegex
{
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let phone = "^[0-9]{10}$"
}

public struct PTCLValidationBirthdateConfig {
    public var fieldName: String = "Birthdate"
    public var minimumAge: Int32?
    public var maximumAge: Int32?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationDateConfig {
    public var fieldName: String = "Date"
    public var minimum: Date?
    public var maximum: Date?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationEmailConfig {
    public var fieldName: String = "Email"
    public var regex: String? = PTCLValidationRegex.email
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationHandleConfig {
    public var fieldName: String = "Handle"
    public var minimumLength: Int32? = 6
    public var maximumLength: Int32? = 80
    public var regex: String?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationNameConfig {
    public var fieldName: String = "Name"
    public var minimumLength: Int32? = 2
    public var maximumLength: Int32? = 250
    public var regex: String?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationNumberConfig {
    public var fieldName: String = "Number"
    public var minimum: Int64?
    public var maximum: Int64?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationPasswordConfig {
    public var fieldName: String = "Password"
    public var minimumLength: Int32?
    public var maximumLength: Int32?
    public var required: Bool = true
    public var strength: PTCLPasswordStrengthType = .strong
    public init() { }
}
public struct PTCLValidationPercentageConfig {
    public var fieldName: String = "Percentage"
    public var minimum: Float?
    public var maximum: Float?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationPhoneConfig {
    public var fieldName: String = "Phone"
    public var minimumLength: Int32? = 10
    public var maximumLength: Int32? = 10
    public var regex: String? = PTCLValidationRegex.phone
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationSearchConfig {
    public var fieldName: String = "Search"
    public var minimumLength: Int32?
    public var maximumLength: Int32?
    public var regex: String?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationStateConfig {
    public var fieldName: String = "State"
    public var minimumLength: Int32? = 2
    public var maximumLength: Int32? = 2
    public var regex: String?
    public var required: Bool = true
    public init() { }
}
public struct PTCLValidationUnsignedNumberConfig {
    public var fieldName: String = "Unsigned Number"
    public var minimum: Int64?
    public var maximum: Int64?
    public var required: Bool = true
    public init() { }
}

public protocol PTCLValidation_Protocol: PTCLBase_Protocol {
    var callNextWhen: PTCLCallNextWhen { get }
    var nextWorker: PTCLValidation_Protocol? { get }

    init()
    init(call callNextWhen: PTCLCallNextWhen,
         nextWorker: PTCLValidation_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doValidateBirthdate(for birthdate: Date?, with config: PTCLValidationBirthdateConfig) throws -> DNSError?
    func doValidateDate(for date: Date?, with config: PTCLValidationDateConfig) throws -> DNSError?
    func doValidateEmail(for email: String?, with config: PTCLValidationEmailConfig) throws -> DNSError?
    func doValidateHandle(for handle: String?, with config: PTCLValidationHandleConfig) throws -> DNSError?
    func doValidateName(for name: String?, with config: PTCLValidationNameConfig) throws -> DNSError?
    func doValidateNumber(for number: String?, with config: PTCLValidationNumberConfig) throws -> DNSError?
    func doValidatePassword(for password: String?, with config: PTCLValidationPasswordConfig) throws -> DNSError?
    func doValidatePercentage(for percentage: String?, with config: PTCLValidationPercentageConfig) throws -> DNSError?
    func doValidatePhone(for phone: String?, with config: PTCLValidationPhoneConfig) throws -> DNSError?
    func doValidateSearch(for search: String?, with config: PTCLValidationSearchConfig) throws -> DNSError?
    func doValidateState(for state: String?, with config: PTCLValidationStateConfig) throws -> DNSError?
    func doValidateUnsignedNumber(for number: String?, with config: PTCLValidationUnsignedNumberConfig) throws -> DNSError?
}
