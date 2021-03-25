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
    case invalid(_ codeLocation: DNSCodeLocation)
    case noValue(_ codeLocation: DNSCodeLocation)
    case tooHigh(_ codeLocation: DNSCodeLocation)
    case tooLong(_ codeLocation: DNSCodeLocation)
    case tooLow(_ codeLocation: DNSCodeLocation)
    case tooOld(_ codeLocation: DNSCodeLocation)
    case tooShort(_ codeLocation: DNSCodeLocation)
    case tooWeak(_ codeLocation: DNSCodeLocation)
    case tooYoung(_ codeLocation: DNSCodeLocation)
    case required(_ codeLocation: DNSCodeLocation)
}
extension PTCLValidationError: DNSError {
    public static let domain = "VALIDATE"
    public enum Code: Int
    {
        case unknown = 1001
        case invalid = 1002
        case noValue = 1003
        case tooHigh = 1004
        case tooLong = 1005
        case tooLow = 1006
        case tooOld = 1007
        case tooShort = 1008
        case tooWeak = 1009
        case tooYoung = 1010
        case required = 1011
    }
    
    public var nsError: NSError! {
        switch self {
        case .unknown(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .invalid(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalid.rawValue,
                                userInfo: userInfo)
        case .noValue(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.noValue.rawValue,
                                userInfo: userInfo)
        case .tooHigh(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooHigh.rawValue,
                                userInfo: userInfo)
        case .tooLong(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooLong.rawValue,
                                userInfo: userInfo)
        case .tooLow(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooLow.rawValue,
                                userInfo: userInfo)
        case .tooOld(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooOld.rawValue,
                                userInfo: userInfo)
        case .tooShort(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooShort.rawValue,
                                userInfo: userInfo)
        case .tooWeak(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooWeak.rawValue,
                                userInfo: userInfo)
        case .tooYoung(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooYoung.rawValue,
                                userInfo: userInfo)
        case .required(let codeLocation):
            var userInfo = codeLocation.userInfo
            userInfo[NSLocalizedDescriptionKey] = self.errorString
            return NSError.init(domain: Self.domain,
                                code: Self.Code.required.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        return self.errorString
    }
    public var errorString: String {
        switch self {
        case .unknown:
            return NSLocalizedString("VALIDATE-Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .invalid:
            return NSLocalizedString("VALIDATE-Invalid Entry", comment: "")
                + " (\(Self.domain):\(Self.Code.invalid.rawValue))"
        case .noValue:
            return NSLocalizedString("VALIDATE-No Entry", comment: "")
                + " (\(Self.domain):\(Self.Code.noValue.rawValue))"
        case .tooHigh:
            return NSLocalizedString("VALIDATE-Entry Too High", comment: "")
                + " (\(Self.domain):\(Self.Code.tooHigh.rawValue))"
        case .tooLong:
            return NSLocalizedString("VALIDATE-Entry Too Long", comment: "")
                + " (\(Self.domain):\(Self.Code.tooLong.rawValue))"
        case .tooLow:
            return NSLocalizedString("VALIDATE-Entry Too Low", comment: "")
                + " (\(Self.domain):\(Self.Code.tooLow.rawValue))"
        case .tooOld:
            return NSLocalizedString("VALIDATE-Entry Too Old", comment: "")
                + " (\(Self.domain):\(Self.Code.tooOld.rawValue))"
        case .tooShort:
            return NSLocalizedString("VALIDATE-Entry Too Short", comment: "")
                + " (\(Self.domain):\(Self.Code.tooShort.rawValue))"
        case .tooWeak:
            return NSLocalizedString("VALIDATE-Entry Too Weak", comment: "")
                + " (\(Self.domain):\(Self.Code.tooWeak.rawValue))"
        case .tooYoung:
            return NSLocalizedString("VALIDATE-Entry Too Young", comment: "")
                + " (\(Self.domain):\(Self.Code.tooYoung.rawValue))"
        case .required:
            return NSLocalizedString("VALIDATE-Entry Required", comment: "")
                + " (\(Self.domain):\(Self.Code.required.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let codeLocation),
             .invalid(let codeLocation),
             .noValue(let codeLocation),
             .tooHigh(let codeLocation),
             .tooLong(let codeLocation),
             .tooLow(let codeLocation),
             .tooOld(let codeLocation),
             .tooShort(let codeLocation),
             .tooWeak(let codeLocation),
             .tooYoung(let codeLocation),
             .required(let codeLocation):
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
    var minimumAge: Int32?
    var maximumAge: Int32?
    var required: Bool = true
}
public struct PTCLValidationDateConfig {
    var minimum: Date?
    var maximum: Date?
    var required: Bool = true
}
public struct PTCLValidationEmailConfig {
    var regex: String? = PTCLValidationRegex.email
    var required: Bool = true
}
public struct PTCLValidationHandleConfig {
    var minimumLength: Int32? = 6
    var maximumLength: Int32? = 80
    var regex: String?
    var required: Bool = true
}
public struct PTCLValidationNameConfig {
    var minimumLength: Int32? = 2
    var maximumLength: Int32? = 250
    var regex: String?
    var required: Bool = true
}
public struct PTCLValidationNumberConfig {
    var minimum: Int64?
    var maximum: Int64?
    var required: Bool = true
}
public struct PTCLValidationPasswordConfig {
    var minimumLength: Int32?
    var maximumLength: Int32?
    var required: Bool = true
    var strength: PTCLPasswordStrengthType = .strong
}
public struct PTCLValidationPercentageConfig {
    var minimum: Float?
    var maximum: Float?
    var required: Bool = true
}
public struct PTCLValidationPhoneConfig {
    var minimumLength: Int32? = 10
    var maximumLength: Int32? = 10
    var regex: String? = PTCLValidationRegex.phone
    var required: Bool = true
}
public struct PTCLValidationSearchConfig {
    var minimumLength: Int32?
    var maximumLength: Int32?
    var regex: String?
    var required: Bool = true
}
public struct PTCLValidationStateConfig {
    var minimumLength: Int32? = 2
    var maximumLength: Int32? = 2
    var regex: String?
    var required: Bool = true
}
public struct PTCLValidationUnsignedNumberConfig {
    var minimum: Int64?
    var maximum: Int64?
    var required: Bool = true
}

public protocol PTCLValidation_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLValidation_Protocol? { get }

    init()
    init(nextWorker: PTCLValidation_Protocol)

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
