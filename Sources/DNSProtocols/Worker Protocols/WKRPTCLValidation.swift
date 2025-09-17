//
//  WKRPTCLValidation.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLValidationRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLValidationResVoid = Result<WKRPTCLValidationRtnVoid, Error>

public protocol WKRPTCLValidation: WKRPTCLWorkerBase {
    typealias Data = WKRPTCLValidationData
    typealias Config = Data.Config

    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLValidation,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doValidateAddress(for address: DNSPostalAddress?,
                           with config: Config.Address) -> WKRPTCLValidationResVoid
    func doValidateAddressCity(for city: String?,
                                 with config: Config.Address.City) -> WKRPTCLValidationResVoid
    func doValidateAddressPostalCode(for postalCode: String?,
                                     with config: Config.Address.PostalCode) -> WKRPTCLValidationResVoid
    func doValidateAddressState(for state: String?,
                                with config: Config.Address.State) -> WKRPTCLValidationResVoid
    func doValidateAddressStreet(for street: String?,
                                 with config: Config.Address.Street) -> WKRPTCLValidationResVoid
    func doValidateAddressStreet2(for street2: String?,
                                  with config: Config.Address.Street2) -> WKRPTCLValidationResVoid
    func doValidateBirthdate(for birthdate: Date?,
                             with config: Config.Birthdate) -> WKRPTCLValidationResVoid
    func doValidateCalendarDate(for calendarDate: Date?,
                                with config: Config.CalendarDate) -> WKRPTCLValidationResVoid
    func doValidateEmail(for email: String?,
                         with config: Config.Email) -> WKRPTCLValidationResVoid
    func doValidateHandle(for handle: String?,
                          with config: Config.Handle) -> WKRPTCLValidationResVoid
    func doValidateName(for name: String?,
                        with config: Config.Name) -> WKRPTCLValidationResVoid
    func doValidateNumber(for numberString: String?,
                          with config: Config.Number) -> WKRPTCLValidationResVoid
    func doValidatePassword(for password: String?,
                            with config: Config.Password) -> WKRPTCLValidationResVoid
    func doValidatePercentage(for percentageString: String?,
                              with config: Config.Percentage) -> WKRPTCLValidationResVoid
    func doValidatePhone(for phone: String?,
                         with config: Config.Phone) -> WKRPTCLValidationResVoid
    func doValidateSearch(for search: String?,
                          with config: Config.Search) -> WKRPTCLValidationResVoid
    func doValidateState(for state: String?,
                         with config: Config.State) -> WKRPTCLValidationResVoid
    func doValidateUnsignedNumber(for numberString: String?,
                                  with config: Config.UnsignedNumber) -> WKRPTCLValidationResVoid
}
