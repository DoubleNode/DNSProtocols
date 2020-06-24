//
//  PTCLValidation_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

import DNSDataObjects
import Foundation

public enum PTCLValidationError: Error
{
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
    public var nsError: NSError! {
        switch self {
        case .invalid(let domain, let file, let line, let method),
             .noValue(let domain, let file, let line, let method),
             .tooHigh(let domain, let file, let line, let method),
             .tooLong(let domain, let file, let line, let method),
             .tooLow(let domain, let file, let line, let method),
             .tooOld(let domain, let file, let line, let method),
             .tooShort(let domain, let file, let line, let method),
             .tooWeak(let domain, let file, let line, let method),
             .tooYoung(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain, "DNSFile": file, "DNSLine": line, "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .invalid(let domain, let file, let line, let method):
            return NSLocalizedString("Invalid Entry (\(domain):\(file):\(line):\(method))", comment: "")
        case .noValue(let domain, let file, let line, let method):
            return NSLocalizedString("No Entry (\(domain):\(file):\(line):\(method))", comment: "")
        case .tooHigh(let domain, let file, let line, let method):
            return NSLocalizedString("Entry Too High (\(domain):\(file):\(line):\(method))", comment: "")
        case .tooLong(let domain, let file, let line, let method):
            return NSLocalizedString("Entry Too Long (\(domain):\(file):\(line):\(method))", comment: "")
        case .tooLow(let domain, let file, let line, let method):
            return NSLocalizedString("Entry Too Low (\(domain):\(file):\(line):\(method))", comment: "")
        case .tooOld(let domain, let file, let line, let method):
            return NSLocalizedString("Entry Too Old (\(domain):\(file):\(line):\(method))", comment: "")
        case .tooShort(let domain, let file, let line, let method):
            return NSLocalizedString("Entry Too Short (\(domain):\(file):\(line):\(method))", comment: "")
        case .tooWeak(let domain, let file, let line, let method):
            return NSLocalizedString("Entry Too Weak (\(domain):\(file):\(line):\(method))", comment: "")
        case .tooYoung(let domain, let file, let line, let method):
            return NSLocalizedString("Entry Too Young (\(domain):\(file):\(line):\(method))", comment: "")
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
