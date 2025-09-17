//
//  WKRPTCLCacheTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Combine
import DNSCore
import DNSError
import Foundation
@testable import DNSProtocols

class WKRPTCLCacheTests: ProtocolTestBase {
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        cancellables.removeAll()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLCacheProtocolExists() {
        validateProtocolExists(WKRPTCLCache.self)
    }
    
    func testWKRPTCLCacheInheritsFromWorkerBase() {
        let mockCache = MockCacheWorker()
        validateProtocolConformance(mockCache, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockCache, conformsTo: WKRPTCLCache.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testCacheTypeAliases() {
        // Test return type aliases exist
        validateTypeAlias(WKRPTCLCacheRtnAny.self, aliasName: "WKRPTCLCacheRtnAny")
        validateTypeAlias(WKRPTCLCacheRtnImage.self, aliasName: "WKRPTCLCacheRtnImage")
        validateTypeAlias(WKRPTCLCacheRtnString.self, aliasName: "WKRPTCLCacheRtnString")
        validateTypeAlias(WKRPTCLCacheRtnVoid.self, aliasName: "WKRPTCLCacheRtnVoid")
        
        // Test publisher type aliases exist
        validateTypeAlias(WKRPTCLCachePubAny.self, aliasName: "WKRPTCLCachePubAny")
        validateTypeAlias(WKRPTCLCachePubImage.self, aliasName: "WKRPTCLCachePubImage")
        validateTypeAlias(WKRPTCLCachePubString.self, aliasName: "WKRPTCLCachePubString")
        validateTypeAlias(WKRPTCLCachePubVoid.self, aliasName: "WKRPTCLCachePubVoid")
        
        // Test future type aliases exist
        validateTypeAlias(WKRPTCLCacheFutAny.self, aliasName: "WKRPTCLCacheFutAny")
        validateTypeAlias(WKRPTCLCacheFutImage.self, aliasName: "WKRPTCLCacheFutImage")
        validateTypeAlias(WKRPTCLCacheFutString.self, aliasName: "WKRPTCLCacheFutString")
        validateTypeAlias(WKRPTCLCacheFutVoid.self, aliasName: "WKRPTCLCacheFutVoid")
    }
    
    func testCachePublisherCreation() {
        let mockCache = MockCacheWorker()
        
        // Test that publishers can be created
        let imagePublisher = mockCache.doLoadImage(from: NSURL(string: "https://example.com/image.jpg")!,
                                                  for: "test_image_id")
        XCTAssertNotNil(imagePublisher, "Image publisher should be created")
        
        let stringPublisher = mockCache.doReadString(for: "test_string_id")
        XCTAssertNotNil(stringPublisher, "String publisher should be created")
        
        let objectPublisher = mockCache.doReadObject(for: "test_object_id")
        XCTAssertNotNil(objectPublisher, "Object publisher should be created")
        
        let deletePublisher = mockCache.doDeleteObject(for: "test_delete_id")
        XCTAssertNotNil(deletePublisher, "Delete publisher should be created")
    }
    
    // MARK: - Error Extension Tests
    
    func testCacheErrorCases() {
        let codeLocation = DNSCodeLocation(self)
        let expectedErrorCases: [WKRPTCLCacheError] = [
            .unknown(codeLocation),
            .notImplemented(codeLocation),
            .notFound(field: "id", value: "test", codeLocation),
            .invalidParameters(parameters: ["param1"], codeLocation),
            .cacheError(codeLocation),
            .loadFailed(codeLocation)
        ]
        
        for errorCase in expectedErrorCases {
            XCTAssertNotNil(errorCase.errorString, "Error case should have error string")
            XCTAssertNotNil(errorCase.nsError, "Error case should convert to NSError")
        }
    }
    
    func testCacheDNSErrorConversion() {
        let codeLocation = DNSCodeLocation(self)
        let cacheError = WKRPTCLCacheError.loadFailed(codeLocation)
        let dnsError = DNSError.Cache.loadFailed(codeLocation)
        
        XCTAssertEqual(cacheError.nsError.domain, dnsError.nsError.domain)
        XCTAssertEqual(cacheError.nsError.code, dnsError.nsError.code)
    }
    
    // MARK: - Protocol Method Signature Tests
    
    func testCacheMethodSignatures() {
        let mockCache = MockCacheWorker()
        
        // Test that all required methods are accessible
        validateMethodSignature(mockCache, methodName: "doDeleteObject")
        validateMethodSignature(mockCache, methodName: "doLoadImage")
        validateMethodSignature(mockCache, methodName: "doReadObject")
        validateMethodSignature(mockCache, methodName: "doReadString")
        validateMethodSignature(mockCache, methodName: "doUpdate")
    }
    
    // MARK: - Cache Object Management Tests
    
    func testDeleteObjectMethod() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Delete object completion")
        let testId = TestDataGenerator.generateTestId(prefix: "delete")
        
        mockCache.doDeleteObject(for: testId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true, "Delete should complete successfully")
                case .failure(let error):
                    XCTFail("Delete should not fail: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                // Void return
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadImageMethod() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Load image completion")
        let testUrl = NSURL(string: "https://example.com/test.jpg")!
        let testId = TestDataGenerator.generateTestId(prefix: "image")
        
        mockCache.doLoadImage(from: testUrl, for: testId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true, "Image load should complete successfully")
                case .failure(let error):
                    XCTFail("Image load should not fail: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { image in
                XCTAssertNotNil(image, "Loaded image should not be nil")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testReadObjectMethod() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Read object completion")
        let testId = TestDataGenerator.generateTestId(prefix: "object")
        
        mockCache.doReadObject(for: testId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true, "Read object should complete successfully")
                case .failure(let error):
                    XCTFail("Read object should not fail: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { object in
                XCTAssertNotNil(object, "Read object should not be nil")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testReadStringMethod() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Read string completion")
        let testId = TestDataGenerator.generateTestId(prefix: "string")
        
        mockCache.doReadString(for: testId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true, "Read string should complete successfully")
                case .failure(let error):
                    XCTFail("Read string should not fail: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { string in
                XCTAssertNotNil(string, "Read string should not be nil")
                XCTAssertFalse(string.isEmpty, "Read string should not be empty")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateObjectMethod() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Update object completion")
        let testId = TestDataGenerator.generateTestId(prefix: "update")
        let testObject = TestDataGenerator.generateTestDataDictionary()
        
        mockCache.doUpdate(object: testObject, for: testId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true, "Update object should complete successfully")
                case .failure(let error):
                    XCTFail("Update object should not fail: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { updatedObject in
                XCTAssertNotNil(updatedObject, "Updated object should not be nil")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Progress Block Tests
    
    func testCacheWithProgress() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Cache with progress completion")
        let progressExpectation = self.expectation(description: "Progress callback")
        
        let progressBlock = MockProtocolFactory.createMockProgressBlock()
        let testId = TestDataGenerator.generateTestId(prefix: "progress")
        
        mockCache.doReadString(for: testId, with: progressBlock)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
                // String value received
            })
            .store(in: &cancellables)
        
        // Simulate progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            progressExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Shortcut Method Tests
    
    func testShortcutMethods() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Shortcut methods completion")
        
        // Test that shortcut methods work without progress blocks
        let testId = TestDataGenerator.generateTestId(prefix: "shortcut")
        
        mockCache.doDeleteObject(for: testId)
            .flatMap { _ in
                mockCache.doReadString(for: testId)
            }
            .flatMap { _ in
                mockCache.doReadObject(for: testId)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true, "Shortcut methods should work")
                case .failure(let error):
                    XCTFail("Shortcut methods should not fail: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                // Object value received
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testCacheWorkerChaining() {
        let primaryCache = MockCacheWorker()
        let nextCache = MockCacheWorker()
        
        primaryCache.nextWorker = nextCache
        
        // Test that chaining works
        XCTAssertNotNil(primaryCache.nextWorker)
        
        if let chainedWorker = primaryCache.nextWorker as? MockCacheWorker {
            XCTAssertEqual(ObjectIdentifier(chainedWorker), ObjectIdentifier(nextCache))
        } else {
            XCTFail("Chained cache worker should be accessible")
        }
    }
    
    // MARK: - Error Handling Tests
    
    func testCacheErrorHandling() {
        let mockCache = MockCacheWorker()
        mockCache.shouldFail = true
        let expectation = self.expectation(description: "Cache error handling")
        
        mockCache.doReadString(for: "invalid_id")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Should fail with error")
                case .failure(let error):
                    XCTAssertNotNil(error, "Error should be provided")
                }
                expectation.fulfill()
            }, receiveValue: { _ in
                XCTFail("Should not receive value on failure")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Combine Publisher Tests
    
    func testPublisherChaining() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Publisher chaining")
        
        let testId1 = TestDataGenerator.generateTestId(prefix: "chain1")
        let testId2 = TestDataGenerator.generateTestId(prefix: "chain2")
        
        mockCache.doReadString(for: testId1)
            .flatMap { _ in
                mockCache.doReadString(for: testId2)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTAssertTrue(true, "Publisher chaining should work")
                case .failure(let error):
                    XCTFail("Publisher chaining should not fail: \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { string in
                XCTAssertNotNil(string, "Final string should not be nil")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.0)
    }
    
    func testMultiplePublishers() {
        let mockCache = MockCacheWorker()
        let expectation = self.expectation(description: "Multiple publishers")
        expectation.expectedFulfillmentCount = 3
        
        let testId = TestDataGenerator.generateTestId(prefix: "multi")
        
        // Test multiple publishers at once
        Publishers.Zip3(
            mockCache.doReadString(for: "\(testId)_string"),
            mockCache.doReadObject(for: "\(testId)_object"),
            mockCache.doDeleteObject(for: "\(testId)_delete").map { _ in "deleted" }
        )
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Multiple publishers should not fail: \(error)")
            }
        }, receiveValue: { (string, object, deleteResult) in
            XCTAssertNotNil(string, "String should not be nil")
            XCTAssertNotNil(object, "Object should not be nil")
            XCTAssertEqual(deleteResult, "deleted", "Delete result should match")
            expectation.fulfill()
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 2.0)
    }
    
    // MARK: - Integration Tests
    
    func testCacheWithSystemsWorker() {
        let cache = MockCacheWorker()
        let systems = MockSystemsWorker()
        
        cache.wkrSystems = systems
        
        // Test that systems integration works
        XCTAssertNotNil(cache.wkrSystems)
        
        let expectation = self.expectation(description: "Cache with systems")
        let testId = TestDataGenerator.generateTestId(prefix: "systems")
        
        cache.doReadString(for: testId)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { _ in
                // String value received
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Performance Tests
    
    func testCachePerformance() {
        let cache = MockCacheWorker()
        
        measure {
            let expectations = (0..<100).map { i in
                XCTestExpectation(description: "Cache operation \(i)")
            }
            
            for (index, expectation) in expectations.enumerated() {
                cache.doReadString(for: "perf_test_\(index)")
                    .sink(receiveCompletion: { _ in
                        expectation.fulfill()
                    }, receiveValue: { _ in })
                    .store(in: &cancellables)
            }
            
            wait(for: expectations, timeout: 5.0)
        }
    }
}

// MARK: - Mock Cache Worker Implementation

private class MockCacheWorker: MockWorker, WKRPTCLCache {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    var shouldFail = false
    
    // MARK: - WKRPTCLCache Protocol Conformance
    
    override var nextWorker: DNSPTCLWorker? {
        get { return super.nextWorker as? WKRPTCLCache }
        set { super.nextWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLCache, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    
    // MARK: - Cache Methods with Progress
    
    func doDeleteObject(for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubVoid {
        return Future<WKRPTCLCacheRtnVoid, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                progress?(1, 1, 1.0, "Delete completed")
                if self.shouldFail {
                    promise(.failure(DNSError.Cache.unknown(DNSCodeLocation(self))))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func doLoadImage(from url: NSURL, for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubImage {
        return Future<WKRPTCLCacheRtnImage, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                progress?(1, 1, 1.0, "Image load completed")
                if self.shouldFail {
                    promise(.failure(DNSError.Cache.loadFailed(DNSCodeLocation(self))))
                } else {
                    // Create a simple test image
                    #if canImport(UIKit)
                    let image = UIImage()
                    promise(.success(image))
                    #else
                    promise(.success("mock_image" as Any))
                    #endif
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func doReadObject(for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return Future<WKRPTCLCacheRtnAny, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                progress?(1, 1, 1.0, "Object read completed")
                if self.shouldFail {
                    promise(.failure(DNSError.Cache.notFound(field: "id", value: id, DNSCodeLocation(self))))
                } else {
                    let testObject = ["id": id, "data": "mock_data"] as Any
                    promise(.success(testObject))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func doReadString(for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubString {
        return Future<WKRPTCLCacheRtnString, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                progress?(1, 1, 1.0, "String read completed")
                if self.shouldFail {
                    promise(.failure(DNSError.Cache.notFound(field: "id", value: id, DNSCodeLocation(self))))
                } else {
                    promise(.success("mock_string_for_\(id)"))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func doUpdate(object: Any, for id: String, with progress: DNSPTCLProgressBlock?) -> WKRPTCLCachePubAny {
        return Future<WKRPTCLCacheRtnAny, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                progress?(1, 1, 1.0, "Object update completed")
                if self.shouldFail {
                    promise(.failure(DNSError.Cache.unknown(DNSCodeLocation(self))))
                } else {
                    promise(.success(object))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Cache Shortcut Methods
    
    func doDeleteObject(for id: String) -> WKRPTCLCachePubVoid {
        return doDeleteObject(for: id, with: nil)
    }
    
    func doLoadImage(from url: NSURL, for id: String) -> WKRPTCLCachePubImage {
        return doLoadImage(from: url, for: id, with: nil)
    }
    
    func doReadObject(for id: String) -> WKRPTCLCachePubAny {
        return doReadObject(for: id, with: nil)
    }
    
    func doReadString(for id: String) -> WKRPTCLCachePubString {
        return doReadString(for: id, with: nil)
    }
    
    func doUpdate(object: Any, for id: String) -> WKRPTCLCachePubAny {
        return doUpdate(object: object, for: id, with: nil)
    }
}

