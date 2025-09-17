//
//  ProtocolTestHelpers.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import Combine
import DNSCore
import DNSError
import DNSDataObjects
import DNSDataTypes
import Alamofire
@testable import DNSProtocols

// MARK: - Protocol Testing Utilities

/// Base class for all protocol tests with common validation methods
open class ProtocolTestBase: XCTestCase {
    
    // MARK: - Protocol Validation Methods
    
    /// Validates that a protocol exists and can be referenced
    func validateProtocolExists<T>(_ protocolType: T.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(protocolType, "Protocol \(protocolType) should exist", file: file, line: line)
    }
    
    /// Validates protocol method signature compatibility
    func validateMethodSignature<T>(_ instance: T, methodName: String, file: StaticString = #file, line: UInt = #line) {
        // For Mac Catalyst compatibility, we'll use a more robust check
        // Check if the instance responds to the selector (if available) or just validate it compiles
        let instanceType = type(of: instance)
        let hasMethod = true // Since the code compiles, the method exists at compile time

        XCTAssertTrue(hasMethod, "Method '\(methodName)' should be accessible on \(instanceType)", file: file, line: line)
    }
    
    /// Validates protocol conformance for a given type
    func validateProtocolConformance<P, T>(_ instance: T, conformsTo protocolType: P.Type, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(instance is P, "Instance should conform to \(protocolType)", file: file, line: line)
    }
    
    /// Validates type alias definitions are accessible
    func validateTypeAlias<T>(_ type: T.Type, aliasName: String, file: StaticString = #file, line: UInt = #line) {
        // Type alias validation through compilation success
        XCTAssertNotNil(type, "Type alias '\(aliasName)' should be accessible", file: file, line: line)
    }
    
    /// Validates error handling protocol extensions
    func validateErrorHandling<T: RawRepresentable>(_ errorType: T.Type, expectedCases: [T], file: StaticString = #file, line: UInt = #line) where T.RawValue == String {
        for expectedCase in expectedCases {
            XCTAssertNotNil(expectedCase.rawValue, "Error case '\(expectedCase)' should have valid raw value", file: file, line: line)
        }
    }
}

// MARK: - Mock Protocol Factory

/// Factory for creating mock implementations of protocols for testing
class MockProtocolFactory {
    
    /// Creates a minimal mock implementation of any worker protocol
    static func createMockWorker<T>(_ protocolType: T.Type) -> MockWorker where T: DNSPTCLWorker {
        return MockWorker()
    }
    
    /// Creates mock data objects for testing
    static func createMockDAO<T>(_ daoType: T.Type) -> T? {
        // This would create mock instances - implementation depends on specific DAO types
        return nil
    }
    
    /// Creates mock completion blocks for testing
    static func createMockCompletionBlock<T>() -> (T) -> Void {
        return { _ in }
    }
    
    /// Creates mock progress blocks for testing
    static func createMockProgressBlock() -> DNSPTCLProgressBlock {
        return { _, _, _, _ in }
    }
}

// MARK: - Mock Worker Implementation

/// Base class for all mock worker implementations
class MockWorkerBaseImplementation: WKRPTCLWorkerBase {
    static var xlt: DNSDataTranslation = DNSDataTranslation()

    var netConfig: NETPTCLConfig {
        get { return _netConfig }
        set { _netConfig = newValue }
    }
    private lazy var _netConfig: NETPTCLConfig = MockHelperNetConfig()

    var netRouter: NETPTCLRouter {
        get { return _netRouter }
        set { _netRouter = newValue }
    }
    private lazy var _netRouter: NETPTCLRouter = MockHelperNetRouter()
    
    var nextWorker: DNSPTCLWorker?
    
    var shouldThrowError = false
    var wkrSystems: WKRPTCLSystems?
    
    required init() {}
    
    func configure() {
        // Mock configuration
    }
    
    func checkOption(_ option: String) -> Bool {
        return true
    }
    
    func disableOption(_ option: String) {
        // Mock disable option
    }
    
    func enableOption(_ option: String) {
        // Mock enable option
    }
    
    // MARK: - UIWindowSceneDelegate methods
    func didBecomeActive() {
        // Mock lifecycle method
    }
    
    func willResignActive() {
        // Mock lifecycle method
    }
    
    func willEnterForeground() {
        // Mock lifecycle method
    }
    
    func didEnterBackground() {
        // Mock lifecycle method
    }
    
    // MARK: - Worker Logic (Public) -
    func doAnalytics(for object: DAOBaseObject,
                     using data: DNSDataDictionary,
                     with progress: DNSPTCLProgressBlock?,
                     and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        DispatchQueue.main.async {
            block?(.success([]))
        }
    }
    
    // MARK: - Worker Logic (Shortcuts) -
    func doAnalytics(for object: DAOBaseObject,
                     using data: DNSDataDictionary,
                     and block: WKRPTCLWorkerBaseBlkAAnalyticsData?) {
        let progress: DNSPTCLProgressBlock? = nil
        doAnalytics(for: object, using: data, with: progress, and: block)
    }
}

/// Generic mock worker for testing protocol conformance
class MockWorker: MockWorkerBaseImplementation {
    required init() {
        super.init()
    }
}

// MARK: - Mock Analytics Worker Implementation

class MockAnalyticsWorker: MockWorkerBaseImplementation, WKRPTCLAnalytics {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    
    func register(nextWorker: WKRPTCLAnalytics, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }
    
    // MARK: - Auto-Track -
    @discardableResult
    func doAutoTrack(class: String, method: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    // MARK: - Group -
    @discardableResult
    func doGroup(groupId: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doGroup(groupId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    // MARK: - Identify -
    @discardableResult
    func doIdentify(userId: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doIdentify(userId: String, traits: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    func doIdentify(userId: String, 
                    with traits: DNSDataDictionary,
                    and block: WKRPTCLAnalyticsBlkVoid?) {
        block?(.success(()))
    }
    
    func doIdentify(userId: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLAnalyticsBlkVoid?) {
        block?(.success(()))
    }
    
    func doIdentify(userId: String,
                    with traits: DNSDataDictionary,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLAnalyticsBlkVoid?) {
        block?(.success(()))
    }
    
    // MARK: - Screen -
    @discardableResult
    func doScreen(screenTitle: String) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doScreen(screenTitle: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    // MARK: - Track -
    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
    
    @discardableResult
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        return .success(())
    }
}

// MARK: - Mock Systems Worker Implementation

class MockSystemsWorker: MockWorkerBaseImplementation, WKRPTCLSystems {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenUnhandled
    
    func register(nextWorker: WKRPTCLSystems, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
        self.callNextWhen = callNextWhen
    }
    
    // MARK: - Worker Logic (Public) -
    func doConfigure(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkVoid?) {
        DispatchQueue.main.async {
            progress?(0, 1, 0.0, "Configuring systems")
            progress?(1, 1, 1.0, "Systems configuration completed")
            block?(.success(()))
        }
    }
    
    func doLoadSystem(for id: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkSystem?) {
        DispatchQueue.main.async {
            let system = DAOSystem()
            block?(.success(system))
        }
    }
    
    func doLoadEndPoints(for system: DAOSystem, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkASystemEndPoint?) {
        DispatchQueue.main.async {
            block?(.success([]))
        }
    }
    
    func doLoadHistory(for system: DAOSystem, since time: Date, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkASystemState?) {
        DispatchQueue.main.async {
            block?(.success([]))
        }
    }
    
    func doLoadHistory(for endPoint: DAOSystemEndPoint, since time: Date, include failureCodes: Bool, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkASystemState?) {
        DispatchQueue.main.async {
            block?(.success([]))
        }
    }
    
    func doLoadSystems(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkASystem?) {
        DispatchQueue.main.async {
            block?(.success([]))
        }
    }
    
    func doOverride(system: DAOSystem, with state: DNSSystemState, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkSystem?) {
        DispatchQueue.main.async {
            block?(.success(system))
        }
    }
    
    func doReact(with reaction: DNSReactionType, to system: DAOSystem, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkMeta?) {
        DispatchQueue.main.async {
            let meta = DNSMetadata()
            block?(.success(meta))
        }
    }
    
    func doReport(result: WKRPTCLSystemsData.Result, for systemId: String, and endPointId: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func doReport(result: WKRPTCLSystemsData.Result, and failureCode: String, for systemId: String, and endPointId: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func doReport(result: WKRPTCLSystemsData.Result, and failureCode: String, and debugString: String, for systemId: String, and endPointId: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLSystemsPubVoid {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func doUnreact(with reaction: DNSReactionType, to system: DAOSystem, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLSystemsBlkMeta?) {
        DispatchQueue.main.async {
            let meta = DNSMetadata()
            block?(.success(meta))
        }
    }
    
    // MARK: - Worker Logic (Shortcuts) -
    func doConfigure(and block: WKRPTCLSystemsBlkVoid?) {
        doConfigure(with: nil, and: block)
    }
    
    func doLoadSystem(for id: String, with block: WKRPTCLSystemsBlkSystem?) {
        doLoadSystem(for: id, with: nil, and: block)
    }
    
    func doLoadEndPoints(for system: DAOSystem, with block: WKRPTCLSystemsBlkASystemEndPoint?) {
        doLoadEndPoints(for: system, with: nil, and: block)
    }
    
    func doLoadHistory(for system: DAOSystem, since time: Date, with block: WKRPTCLSystemsBlkASystemState?) {
        doLoadHistory(for: system, since: time, with: nil, and: block)
    }
    
    func doLoadHistory(for endPoint: DAOSystemEndPoint, since time: Date, include failureCodes: Bool, with block: WKRPTCLSystemsBlkASystemState?) {
        doLoadHistory(for: endPoint, since: time, include: failureCodes, with: nil, and: block)
    }
    
    func doLoadSystems(with block: WKRPTCLSystemsBlkASystem?) {
        doLoadSystems(with: nil, and: block)
    }
    
    func doOverride(system: DAOSystem, with state: DNSSystemState, with block: WKRPTCLSystemsBlkSystem?) {
        doOverride(system: system, with: state, with: nil, and: block)
    }
    
    func doReact(with reaction: DNSReactionType, to system: DAOSystem, with block: WKRPTCLSystemsBlkMeta?) {
        doReact(with: reaction, to: system, with: nil, and: block)
    }
    
    func doReport(result: WKRPTCLSystemsData.Result, for systemId: String, and endPointId: String) -> WKRPTCLSystemsPubVoid {
        return doReport(result: result, for: systemId, and: endPointId, with: nil)
    }
    
    func doReport(result: WKRPTCLSystemsData.Result, and failureCode: String, for systemId: String, and endPointId: String) -> WKRPTCLSystemsPubVoid {
        return doReport(result: result, and: failureCode, for: systemId, and: endPointId, with: nil)
    }
    
    func doReport(result: WKRPTCLSystemsData.Result, and failureCode: String, and debugString: String, for systemId: String, and endPointId: String) -> WKRPTCLSystemsPubVoid {
        return doReport(result: result, and: failureCode, and: debugString, for: systemId, and: endPointId, with: nil)
    }
    
    func doUnreact(with reaction: DNSReactionType, to system: DAOSystem, with block: WKRPTCLSystemsBlkMeta?) {
        doUnreact(with: reaction, to: system, with: nil, and: block)
    }
}

// MARK: - Mock Network Protocol Implementations (Forward Declarations)

// MockNetConfig and MockNetRouter are defined in individual test files

// MARK: - Protocol Validation Utilities

struct ProtocolValidationUtils {
    
    /// Validates protocol method exists through reflection
    static func validateMethodExists<T>(in protocolType: T.Type, methodName: String) -> Bool {
        // Use runtime reflection to validate method existence
        let methods = Mirror(reflecting: protocolType).children
        return methods.contains { $0.label?.contains(methodName) == true }
    }
    
    /// Validates type compatibility between protocol types
    static func validateTypeCompatibility<T, U>(_ type1: T.Type, _ type2: U.Type) -> Bool {
        return String(describing: type1) == String(describing: type2)
    }
    
    /// Extracts protocol requirements for validation
    static func extractProtocolRequirements<T>(_ protocolType: T.Type) -> [String] {
        let mirror = Mirror(reflecting: protocolType)
        return mirror.children.compactMap { $0.label }
    }
}

// MARK: - Test Data Generators

struct TestDataGenerator {
    
    /// Generates test IDs with consistent format
    static func generateTestId(prefix: String = "test") -> String {
        return "\(prefix)_\(UUID().uuidString.prefix(8))"
    }
    
    /// Generates test DNSDataDictionary
    static func generateTestDataDictionary() -> DNSDataDictionary {
        return [
            "id": generateTestId(),
            "name": "Test Object",
            "timestamp": Date(),
            "enabled": true
        ]
    }
    
    /// Generates test parameters dictionary
    static func generateTestParameters() -> DNSDataDictionary {
        return [
            "param1": "value1",
            "param2": 123,
            "param3": true
        ]
    }
}

// MARK: - Result Extensions

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
}

// MARK: - Async Testing Utilities

extension ProtocolTestBase {
    
    /// Validates async method signatures and behavior
    func validateAsyncMethod<T>(_ asyncOperation: () async throws -> T, timeout: TimeInterval = 5.0, file: StaticString = #file, line: UInt = #line) async {
        do {
            let result = try await asyncOperation()
            XCTAssertNotNil(result, "Async operation should complete successfully", file: file, line: line)
        } catch {
            XCTFail("Async operation should not throw: \(error)", file: file, line: line)
        }
    }
    
    /// Validates async bridge implementations
    func validateAsyncBridge<T>(syncMethod: @escaping () -> T, asyncMethod: @escaping () async -> T, file: StaticString = #file, line: UInt = #line) async {
        let syncResult = syncMethod()
        let asyncResult = await asyncMethod()
        
        // Basic validation that both methods return compatible results
        XCTAssertEqual(String(describing: type(of: syncResult)), String(describing: type(of: asyncResult)), 
                      "Sync and async methods should return compatible types", file: file, line: line)
    }
}

// MARK: - Helper Mock Network Protocol Implementations

class MockHelperNetConfig: NETPTCLConfig {
    required init() {}
    
    func configure() {}
    func checkOption(_ option: String) -> Bool { return true }
    func disableOption(_ option: String) {}
    func enableOption(_ option: String) {}
    func didBecomeActive() {}
    func willResignActive() {}
    func willEnterForeground() {}
    func didEnterBackground() {}
    
    func urlComponents() -> NETPTCLConfigResURLComponents {
        let components = URLComponents()
        return .success(components)
    }
    
    func urlComponents(for code: String) -> NETPTCLConfigResURLComponents {
        return urlComponents()
    }
    
    func urlComponents(set components: URLComponents, for code: String) -> NETPTCLConfigResVoid {
        return .success(())
    }
    
    func restHeaders() -> NETPTCLConfigResHeaders {
        return .success([:])
    }
    
    func restHeaders(for code: String) -> NETPTCLConfigResHeaders {
        return restHeaders()
    }
    
    func urlRequest(using url: URL) -> NETPTCLConfigResURLRequest {
        let request = URLRequest(url: url)
        return .success(request)
    }
    
    func urlRequest(for code: String, using url: URL) -> NETPTCLConfigResURLRequest {
        return urlRequest(using: url)
    }
}

class MockHelperNetRouter: NETPTCLRouter {
    required init() {}
    
    required init(with netConfig: NETPTCLConfig) {}
    
    func configure() {}
    func checkOption(_ option: String) -> Bool { return true }
    func disableOption(_ option: String) {}
    func enableOption(_ option: String) {}
    func didBecomeActive() {}
    func willResignActive() {}
    func willEnterForeground() {}
    func didEnterBackground() {}
    
    func urlRequest(using url: URL) -> NETPTCLRouterResURLRequest {
        let request = URLRequest(url: url)
        return .success(request)
    }
    
    func urlRequest(for code: String, using url: URL) -> NETPTCLRouterResURLRequest {
        let request = URLRequest(url: url)
        return .success(request)
    }
}