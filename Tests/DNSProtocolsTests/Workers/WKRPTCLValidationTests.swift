//
//  WKRPTCLValidationTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSDataObjects
import DNSError
@testable import DNSProtocols

class WKRPTCLValidationTests: ProtocolTestBase {
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLValidationProtocolExists() {
        validateProtocolExists(WKRPTCLValidation.self)
    }
    
    func testWKRPTCLValidationInheritsFromWorkerBase() {
        let mockValidation = MockValidationWorker()
        validateProtocolConformance(mockValidation, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockValidation, conformsTo: WKRPTCLValidation.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testValidationTypeAliases() {
        // Test return type aliases exist
        validateTypeAlias(WKRPTCLValidationRtnVoid.self, aliasName: "WKRPTCLValidationRtnVoid")
        validateTypeAlias(WKRPTCLValidationResVoid.self, aliasName: "WKRPTCLValidationResVoid")
    }
    
    func testValidationDataTypes() {
        // Test that validation data structures exist
        XCTAssertNotNil(WKRPTCLValidationData.self, "Validation data should exist")
        XCTAssertNotNil(WKRPTCLValidationData.Config.self, "Validation config should exist")
        
        // Test specific config types
        let addressConfig = WKRPTCLValidationData.Config.Address()
        XCTAssertNotNil(addressConfig, "Address config should be creatable")
        
        let emailConfig = WKRPTCLValidationData.Config.Email()
        XCTAssertNotNil(emailConfig, "Email config should be creatable")
        
        let phoneConfig = WKRPTCLValidationData.Config.Phone()
        XCTAssertNotNil(phoneConfig, "Phone config should be creatable")
        
        let passwordConfig = WKRPTCLValidationData.Config.Password()
        XCTAssertNotNil(passwordConfig, "Password config should be creatable")
    }
    
    func testValidationRegexPatterns() {
        // Test that regex patterns are defined
        XCTAssertFalse(WKRPTCLValidationData.Regex.email.isEmpty, "Email regex should not be empty")
        XCTAssertFalse(WKRPTCLValidationData.Regex.phone.isEmpty, "Phone regex should not be empty")
        XCTAssertFalse(WKRPTCLValidationData.Regex.state.isEmpty, "State regex should not be empty")
        XCTAssertFalse(WKRPTCLValidationData.Regex.postalCode.isEmpty, "Postal code regex should not be empty")
    }
    
    // MARK: - Error Extension Tests
    
    func testValidationErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLValidationError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .invalid(fieldName: "email", codeLocation),
            .required(fieldName: "name", codeLocation),
            .tooShort(fieldName: "password", codeLocation),
            .tooLong(fieldName: "comment", codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testValidationDNSErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let validationError = WKRPTCLValidationError.invalid(fieldName: "email", codeLocation)
        let dnsError = DNSError.Validation.invalid(fieldName: "email", codeLocation)
        
        XCTAssertEqual(validationError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(validationError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testValidationMethodSignatures() {
        let mockValidation = MockValidationWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockValidation, methodName: "doValidateAddress")
        validateMethodSignature(mockValidation, methodName: "doValidateAddressCity")
        validateMethodSignature(mockValidation, methodName: "doValidateAddressPostalCode")
        validateMethodSignature(mockValidation, methodName: "doValidateAddressState")
        validateMethodSignature(mockValidation, methodName: "doValidateAddressStreet")
        validateMethodSignature(mockValidation, methodName: "doValidateAddressStreet2")
        validateMethodSignature(mockValidation, methodName: "doValidateBirthdate")
        validateMethodSignature(mockValidation, methodName: "doValidateCalendarDate")
        validateMethodSignature(mockValidation, methodName: "doValidateEmail")
        validateMethodSignature(mockValidation, methodName: "doValidateHandle")
        validateMethodSignature(mockValidation, methodName: "doValidateName")
        validateMethodSignature(mockValidation, methodName: "doValidateNumber")
        validateMethodSignature(mockValidation, methodName: "doValidatePassword")
        validateMethodSignature(mockValidation, methodName: "doValidatePercentage")
        validateMethodSignature(mockValidation, methodName: "doValidatePhone")
        validateMethodSignature(mockValidation, methodName: "doValidateSearch")
        validateMethodSignature(mockValidation, methodName: "doValidateState")
        validateMethodSignature(mockValidation, methodName: "doValidateUnsignedNumber")
    }
    
    // MARK: - String Validation Tests
    
    func testValidateEmailMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Email()
        
        // Test valid email
        let validResult = mockValidation.doValidateEmail(for: "test@example.com", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid email should pass validation")
        
        // Test invalid email
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateEmail(for: "invalid-email", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Invalid email should fail validation")
    }
    
    func testValidatePhoneMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Phone()
        
        // Test valid phone
        let validResult = mockValidation.doValidatePhone(for: "1234567890", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid phone should pass validation")
        
        // Test invalid phone
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidatePhone(for: "123", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Invalid phone should fail validation")
    }
    
    func testValidateNameMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Name()
        
        // Test valid name
        let validResult = mockValidation.doValidateName(for: "John Doe", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid name should pass validation")
        
        // Test invalid name (too short)
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateName(for: "J", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Too short name should fail validation")
    }
    
    func testValidateHandleMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Handle()
        
        // Test valid handle
        let validResult = mockValidation.doValidateHandle(for: "testuser123", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid handle should pass validation")
        
        // Test invalid handle (too short)
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateHandle(for: "test", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Too short handle should fail validation")
    }
    
    func testValidatePasswordMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Password()
        
        // Test valid password
        let validResult = mockValidation.doValidatePassword(for: "StrongPassword123!", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid password should pass validation")
        
        // Test invalid password
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidatePassword(for: "weak", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Weak password should fail validation")
    }
    
    func testValidateSearchMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Search()
        
        // Test valid search term
        let validResult = mockValidation.doValidateSearch(for: "search term", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid search should pass validation")
        
        // Test empty search (if required)
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateSearch(for: "", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Empty search should fail validation if required")
    }
    
    // MARK: - Number Validation Tests
    
    func testValidateNumberMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Number()
        
        // Test valid number
        let validResult = mockValidation.doValidateNumber(for: "123", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid number should pass validation")
        
        // Test invalid number
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateNumber(for: "not-a-number", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Invalid number should fail validation")
    }
    
    func testValidateUnsignedNumberMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.UnsignedNumber()
        
        // Test valid unsigned number
        let validResult = mockValidation.doValidateUnsignedNumber(for: "456", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid unsigned number should pass validation")
        
        // Test invalid unsigned number (negative)
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateUnsignedNumber(for: "-123", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Negative number should fail unsigned validation")
    }
    
    func testValidatePercentageMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Percentage()
        
        // Test valid percentage
        let validResult = mockValidation.doValidatePercentage(for: "75.5", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid percentage should pass validation")
        
        // Test invalid percentage
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidatePercentage(for: "invalid", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Invalid percentage should fail validation")
    }
    
    // MARK: - Date Validation Tests
    
    func testValidateBirthdateMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Birthdate()
        let validBirthdate = Calendar.current.date(byAdding: .year, value: -25, to: Date())
        
        // Test valid birthdate
        let validResult = mockValidation.doValidateBirthdate(for: validBirthdate, with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid birthdate should pass validation")
        
        // Test invalid birthdate (future date)
        mockValidation.shouldFailValidation = true
        let futureBirthdate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        let invalidResult = mockValidation.doValidateBirthdate(for: futureBirthdate, with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Future birthdate should fail validation")
    }
    
    func testValidateCalendarDateMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.CalendarDate()
        let testDate = Date()
        
        // Test valid calendar date
        let validResult = mockValidation.doValidateCalendarDate(for: testDate, with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid calendar date should pass validation")
        
        // Test nil date when required
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateCalendarDate(for: nil, with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Nil date should fail validation when required")
    }
    
    // MARK: - Address Validation Tests
    
    func testValidateAddressMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Address()
        let testAddress = DNSPostalAddress()
        
        // Test valid address
        let validResult = mockValidation.doValidateAddress(for: testAddress, with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid address should pass validation")
        
        // Test invalid address
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateAddress(for: nil, with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Nil address should fail validation when required")
    }
    
    func testValidateAddressCityMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Address.City()
        
        // Test valid city
        let validResult = mockValidation.doValidateAddressCity(for: "New York", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid city should pass validation")
        
        // Test invalid city
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateAddressCity(for: "A", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Too short city should fail validation")
    }
    
    func testValidateAddressStateMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Address.State()
        
        // Test valid state
        let validResult = mockValidation.doValidateAddressState(for: "NY", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid state should pass validation")
        
        // Test invalid state
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateAddressState(for: "N", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Invalid state should fail validation")
    }
    
    func testValidateAddressPostalCodeMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Address.PostalCode()
        
        // Test valid postal code
        let validResult = mockValidation.doValidateAddressPostalCode(for: "12345", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid postal code should pass validation")
        
        // Test invalid postal code
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateAddressPostalCode(for: "123", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Invalid postal code should fail validation")
    }
    
    func testValidateAddressStreetMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Address.Street()
        
        // Test valid street address
        let validResult = mockValidation.doValidateAddressStreet(for: "123 Main St", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid street address should pass validation")
        
        // Test invalid street address
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateAddressStreet(for: "A", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Too short street address should fail validation")
    }
    
    func testValidateAddressStreet2Method() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.Address.Street2()
        
        // Test valid street2 (optional)
        let validResult = mockValidation.doValidateAddressStreet2(for: "Apt 4B", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid street2 should pass validation")
        
        // Test nil street2 (should be allowed as optional)
        let nilResult = mockValidation.doValidateAddressStreet2(for: nil, with: config)
        XCTAssertNoThrow(try nilResult.get(), "Nil street2 should pass validation when optional")
    }
    
    func testValidateStateMethod() {
        let mockValidation = MockValidationWorker()
        let config = WKRPTCLValidationData.Config.State()
        
        // Test valid state
        let validResult = mockValidation.doValidateState(for: "California", with: config)
        XCTAssertNoThrow(try validResult.get(), "Valid state name should pass validation")
        
        // Test invalid state
        mockValidation.shouldFailValidation = true
        let invalidResult = mockValidation.doValidateState(for: "CA", with: config)
        XCTAssertThrowsError(try invalidResult.get(), "Too short state should fail validation")
    }
    
    // MARK: - Configuration Tests
    
    func testValidationConfigDefaults() {
        // Test that default configurations are reasonable
        let emailConfig = WKRPTCLValidationData.Config.Email()
        XCTAssertEqual(emailConfig.fieldName, "Email")
        XCTAssertNotNil(emailConfig.regex)
        XCTAssertTrue(emailConfig.required)
        
        let phoneConfig = WKRPTCLValidationData.Config.Phone()
        XCTAssertEqual(phoneConfig.fieldName, "Phone")
        XCTAssertEqual(phoneConfig.minimumLength, 10)
        XCTAssertEqual(phoneConfig.maximumLength, 10)
        XCTAssertTrue(phoneConfig.required)
        
        let passwordConfig = WKRPTCLValidationData.Config.Password()
        XCTAssertEqual(passwordConfig.fieldName, "Password")
        XCTAssertTrue(passwordConfig.required)
    }
    
    func testValidationConfigCustomization() {
        // Test that configurations can be customized
        let customEmailConfig = WKRPTCLValidationData.Config.Email(
            fieldName: "Email Address",
            regex: "custom-regex",
            required: false
        )
        XCTAssertEqual(customEmailConfig.fieldName, "Email Address")
        XCTAssertEqual(customEmailConfig.regex, "custom-regex")
        XCTAssertFalse(customEmailConfig.required)
        
        let customNameConfig = WKRPTCLValidationData.Config.Name(
            fieldName: "Full Name",
            minimumLength: 5,
            maximumLength: 100,
            required: true
        )
        XCTAssertEqual(customNameConfig.fieldName, "Full Name")
        XCTAssertEqual(customNameConfig.minimumLength, 5)
        XCTAssertEqual(customNameConfig.maximumLength, 100)
        XCTAssertTrue(customNameConfig.required)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testValidationWorkerChaining() {
        let primaryValidation = MockValidationWorker()
        let nextValidation = MockValidationWorker()
        
        primaryValidation.nextWorker = nextValidation
        
        // Test that chaining works
        XCTAssertNotNil(primaryValidation.nextWorker)
        
        if let chainedWorker = primaryValidation.nextWorker as? MockValidationWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextValidation))
        } else {
            XCTFail("Chained validation worker should be accessible")
        }
    }
    
    // MARK: - Integration Tests
    
    func testValidationWithSystemsWorker() {
        let validation = MockValidationWorker()
        let systems = MockSystemsWorker()
        
        validation.wkrSystems = systems
        
        // Test that systems integration works
        XCTAssertNotNil(validation.wkrSystems)
        
        let config = WKRPTCLValidationData.Config.Email()
        let result = validation.doValidateEmail(for: "test@example.com", with: config)
        XCTAssertNoThrow(try result.get(), "Validation with systems should work")
    }
}

// MARK: - Mock Validation Worker Implementation

private class MockValidationWorker: MockWorker, WKRPTCLValidation {
    var shouldFailValidation = false
    
    // MARK: - WKRPTCLValidation Protocol Conformance
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    
    // MARK: - WKRPTCLValidation Protocol Properties
    var nextWorker: WKRPTCLValidation? {
        get { return nextBaseWorker as? WKRPTCLValidation }
        set { nextBaseWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLValidation, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    
    // MARK: - Address Validation Methods
    
    func doValidateAddress(for address: DNSPostalAddress?, with config: WKRPTCLValidationData.Config.Address) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (address == nil && config.street.required) {
            return .failure(DNSError.Validation.required(fieldName: config.street.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateAddressCity(for city: String?, with config: WKRPTCLValidationData.Config.Address.City) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (city == nil && config.required) || (city?.count ?? 0) < (config.minimumLength ?? 0) {
            return .failure(DNSError.Validation.tooShort(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateAddressPostalCode(for postalCode: String?, with config: WKRPTCLValidationData.Config.Address.PostalCode) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (postalCode == nil && config.required) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateAddressState(for state: String?, with config: WKRPTCLValidationData.Config.Address.State) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (state == nil && config.required) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateAddressStreet(for street: String?, with config: WKRPTCLValidationData.Config.Address.Street) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (street == nil && config.required) || (street?.count ?? 0) < (config.minimumLength ?? 0) {
            return .failure(DNSError.Validation.tooShort(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateAddressStreet2(for street2: String?, with config: WKRPTCLValidationData.Config.Address.Street2) -> WKRPTCLValidationResVoid {
        if shouldFailValidation && config.required && street2 == nil {
            return .failure(DNSError.Validation.required(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    // MARK: - Date Validation Methods
    
    func doValidateBirthdate(for birthdate: Date?, with config: WKRPTCLValidationData.Config.Birthdate) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (birthdate == nil && config.required) || (birthdate != nil && birthdate! > Date()) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateCalendarDate(for calendarDate: Date?, with config: WKRPTCLValidationData.Config.CalendarDate) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (calendarDate == nil && config.required) {
            return .failure(DNSError.Validation.required(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    // MARK: - String Validation Methods
    
    func doValidateEmail(for email: String?, with config: WKRPTCLValidationData.Config.Email) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (email == nil && config.required) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateHandle(for handle: String?, with config: WKRPTCLValidationData.Config.Handle) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (handle == nil && config.required) || (handle?.count ?? 0) < (config.minimumLength ?? 0) {
            return .failure(DNSError.Validation.tooShort(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateName(for name: String?, with config: WKRPTCLValidationData.Config.Name) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (name == nil && config.required) || (name?.count ?? 0) < (config.minimumLength ?? 0) {
            return .failure(DNSError.Validation.tooShort(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidatePassword(for password: String?, with config: WKRPTCLValidationData.Config.Password) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (password == nil && config.required) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidatePhone(for phone: String?, with config: WKRPTCLValidationData.Config.Phone) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (phone == nil && config.required) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateSearch(for search: String?, with config: WKRPTCLValidationData.Config.Search) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (search?.isEmpty == true && config.required) {
            return .failure(DNSError.Validation.required(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateState(for state: String?, with config: WKRPTCLValidationData.Config.State) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (state == nil && config.required) || (state?.count ?? 0) < (config.minimumLength ?? 0) {
            return .failure(DNSError.Validation.tooShort(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    // MARK: - Number Validation Methods
    
    func doValidateNumber(for numberString: String?, with config: WKRPTCLValidationData.Config.Number) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (numberString == nil && config.required) || (numberString != nil && Int64(numberString!) == nil) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidatePercentage(for percentageString: String?, with config: WKRPTCLValidationData.Config.Percentage) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (percentageString == nil && config.required) || (percentageString != nil && Float(percentageString!) == nil) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
    
    func doValidateUnsignedNumber(for numberString: String?, with config: WKRPTCLValidationData.Config.UnsignedNumber) -> WKRPTCLValidationResVoid {
        if shouldFailValidation || (numberString == nil && config.required) || (numberString != nil && UInt64(numberString!) == nil) {
            return .failure(DNSError.Validation.invalid(fieldName: config.fieldName, DNSCodeLocation(self)))
        }
        return .success(())
    }
}

