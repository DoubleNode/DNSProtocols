//
//  PTCLValidation_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import Foundation

public enum PTCLValidationError: Error
{
    case unknown(domain: String, file: String, line: String, method: String)
    case invalid(domain: String, file: String, line: String, method: String)
    case noValue(domain: String, file: String, line: String, method: String)
    case tooHigh(domain: String, file: String, line: String, method: String)
    case tooLong(domain: String, file: String, line: String, method: String)
    case tooLow(domain: String, file: String, line: String, method: String)
    case tooOld(domain: String, file: String, line: String, method: String)
    case tooShort(domain: String, file: String, line: String, method: String)
    case tooWeak(domain: String, file: String, line: String, method: String)
    case tooYoung(domain: String, file: String, line: String, method: String)
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
        case .unknown(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.unknown.rawValue,
                                userInfo: userInfo)
        case .invalid(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.invalid.rawValue,
                                userInfo: userInfo)
        case .noValue(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.noValue.rawValue,
                                userInfo: userInfo)
        case .tooHigh(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooHigh.rawValue,
                                userInfo: userInfo)
        case .tooLong(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooLong.rawValue,
                                userInfo: userInfo)
        case .tooLow(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooLow.rawValue,
                                userInfo: userInfo)
        case .tooOld(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooOld.rawValue,
                                userInfo: userInfo)
        case .tooShort(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooShort.rawValue,
                                userInfo: userInfo)
        case .tooWeak(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooWeak.rawValue,
                                userInfo: userInfo)
        case .tooYoung(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            let userInfo: [String : Any] = [
                "DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"
            ]
            return NSError.init(domain: Self.domain,
                                code: Self.Code.tooYoung.rawValue,
                                userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Unknown Error", comment: "")
                + " (\(Self.domain):\(Self.Code.unknown.rawValue))"
        case .invalid:
            return NSLocalizedString("Invalid Entry", comment: "")
                + " (\(Self.domain):\(Self.Code.invalid.rawValue))"
        case .noValue:
            return NSLocalizedString("No Entry", comment: "")
                + " (\(Self.domain):\(Self.Code.noValue.rawValue))"
        case .tooHigh:
            return NSLocalizedString("Entry Too High", comment: "")
                + " (\(Self.domain):\(Self.Code.tooHigh.rawValue))"
        case .tooLong:
            return NSLocalizedString("Entry Too Long", comment: "")
                + " (\(Self.domain):\(Self.Code.tooLong.rawValue))"
        case .tooLow:
            return NSLocalizedString("Entry Too Low", comment: "")
                + " (\(Self.domain):\(Self.Code.tooLow.rawValue))"
        case .tooOld:
            return NSLocalizedString("Entry Too Old", comment: "")
                + " (\(Self.domain):\(Self.Code.tooOld.rawValue))"
        case .tooShort:
            return NSLocalizedString("Entry Too Short", comment: "")
                + " (\(Self.domain):\(Self.Code.tooShort.rawValue))"
        case .tooWeak:
            return NSLocalizedString("Entry Too Weak", comment: "")
                + " (\(Self.domain):\(Self.Code.tooWeak.rawValue))"
        case .tooYoung:
            return NSLocalizedString("Entry Too Young", comment: "")
                + " (\(Self.domain):\(Self.Code.tooYoung.rawValue))"
        }
    }
    public var failureReason: String? {
        switch self {
        case .unknown(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .invalid(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .noValue(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .tooHigh(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .tooLong(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .tooLow(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .tooOld(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .tooShort(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .tooWeak(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
        case .tooYoung(let domain, let file, let line, let method):
            let file = DNSCore.shortenErrorFilename(filename: file)
            return "\(domain):\(file):\(line):\(method)"
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

    func doValidateBirthdate(for birthdate: Date,
                             with progress: PTCLProgressBlock?,
                             and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidateEmail(for email: String,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidateHandle(for handle: String,
                          with progress: PTCLProgressBlock?,
                          and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidateName(for name: String,
                        with progress: PTCLProgressBlock?,
                        and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidateNumber(for number: String,
                          with progress: PTCLProgressBlock?,
                          and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidatePassword(for password: String,
                            with progress: PTCLProgressBlock?,
                            and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidatePercentage(for percentage: String,
                              with progress: PTCLProgressBlock?,
                              and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidatePhone(for phone: String,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidateSearch(for search: String,
                          with progress: PTCLProgressBlock?,
                          and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidateState(for state: String,
                         with progress: PTCLProgressBlock?,
                         and block: PTCLValidationBlockVoidBoolDNSError?) throws
    func doValidateUnsignedNumber(for number: String,
                                  with progress: PTCLProgressBlock?,
                                  and block: PTCLValidationBlockVoidBoolDNSError?) throws
}
