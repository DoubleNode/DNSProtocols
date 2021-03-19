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
             .tooYoung(let codeLocation):
            return codeLocation.failureReason
        }
    }
}

// (valid: Bool, error: DNSError?)
public typealias PTCLValidationBlockVoidBoolDNSError = (Bool, DNSError?) -> Void

public protocol PTCLValidation_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLValidation_Protocol? { get }

    var minimumBirthdateAge: Int32 { get set }  // -1 = no minimum
    var maximumBirthdateAge: Int32 { get set }  // -1 = no maximum

    var minimumHandleLength: Int32 { get set }  // -1 = no minimum
    var maximumHandleLength: Int32 { get set }  // -1 = no maximum

    var minimumNameLength: Int32 { get set }    // -1 = no minimum
    var maximumNameLength: Int32 { get set }    // -1 = no maximum

    var minimumNumberValue: Int64 { get set }   // -1 = no minimum
    var maximumNumberValue: Int64 { get set }   // -1 = no maximum

    var minimumPercentageValue: Float { get set }   // <0 = no minimum
    var maximumPercentageValue: Float { get set }   // <0 = no maximum

    var minimumPhoneLength: Int32 { get set }   // -1 = no minimum
    var maximumPhoneLength: Int32 { get set }   // -1 = no maximum

    var minimumUnsignedNumberValue: Int64 { get set }   // -1 = no minimum
    var maximumUnsignedNumberValue: Int64 { get set }   // -1 = no maximum

    var requiredPasswordStrength: PTCLPasswordStrengthType { get set }
    
    init()
    init(nextWorker: PTCLValidation_Protocol)

    // MARK: - Business Logic / Single Item CRUD

    func doValidateBirthdate(for birthdate: Date) throws -> DNSError?
    func doValidateEmail(for email: String) throws -> DNSError?
    func doValidateHandle(for handle: String) throws -> DNSError?
    func doValidateName(for name: String) throws -> DNSError?
    func doValidateNumber(for number: String) throws -> DNSError?
    func doValidatePassword(for password: String) throws -> DNSError?
    func doValidatePercentage(for percentage: String) throws -> DNSError?
    func doValidatePhone(for phone: String) throws -> DNSError?
    func doValidateSearch(for search: String) throws -> DNSError?
    func doValidateState(for state: String) throws -> DNSError?
    func doValidateUnsignedNumber(for number: String) throws -> DNSError?
}
