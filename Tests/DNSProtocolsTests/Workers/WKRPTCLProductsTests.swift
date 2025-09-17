//
//  WKRPTCLProductsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
@testable import DNSProtocols

class WKRPTCLProductsTests: ProtocolTestBase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLProductsProtocolExists() {
        validateProtocolExists(WKRPTCLProducts.self)
    }
    
    func testWKRPTCLProductsInheritsFromWorkerBase() {
        let mockProducts = MockProductsWorker()
        validateProtocolConformance(mockProducts, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockProducts, conformsTo: WKRPTCLProducts.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testProductsTypeAliases() {
        validateTypeAlias(WKRPTCLProductsRtnAProduct.self, aliasName: "WKRPTCLProductsRtnAProduct")
        validateTypeAlias(WKRPTCLProductsRtnProduct.self, aliasName: "WKRPTCLProductsRtnProduct")
        validateTypeAlias(WKRPTCLProductsRtnVoid.self, aliasName: "WKRPTCLProductsRtnVoid")
        validateTypeAlias(WKRPTCLProductsBlkAProduct.self, aliasName: "WKRPTCLProductsBlkAProduct")
        validateTypeAlias(WKRPTCLProductsBlkProduct.self, aliasName: "WKRPTCLProductsBlkProduct")
        validateTypeAlias(WKRPTCLProductsBlkVoid.self, aliasName: "WKRPTCLProductsBlkVoid")
    }
    
    // MARK: - Product Methods Tests
    
    func testLoadProductsMethod() {
        let mockProducts = MockProductsWorker()
        let expectation = self.expectation(description: "Load products completion")
        
        mockProducts.doLoadProducts { result in
            switch result {
            case .success(let products):
                XCTAssertNotNil(products, "Products should not be nil")
            case .failure(let error):
                XCTFail("Load products should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadProductMethod() {
        let mockProducts = MockProductsWorker()
        let expectation = self.expectation(description: "Load product completion")
        let testId = TestDataGenerator.generateTestId(prefix: "product")
        
        mockProducts.doLoadProduct(for: testId) { result in
            switch result {
            case .success(let product):
                XCTAssertNotNil(product, "Product should not be nil")
            case .failure(let error):
                XCTFail("Load product should not fail: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUpdateProductMethod() {
        let mockProducts = MockProductsWorker()
        let expectation = self.expectation(description: "Update product completion")
        let testProduct = DAOProduct()

        mockProducts.doUpdate(testProduct) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Update product should succeed")
            case .failure(let error):
                XCTFail("Update product should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
    
    
    func testRemoveProductMethod() {
        let mockProducts = MockProductsWorker()
        let expectation = self.expectation(description: "Remove product completion")
        let testProduct = DAOProduct()

        mockProducts.doRemove(testProduct) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Remove product should succeed")
            case .failure(let error):
                XCTFail("Remove product should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
    
    
    // MARK: - Chain of Responsibility Tests
    
    func testProductsWorkerChaining() {
        let primaryProducts = MockProductsWorker()
        let nextProducts = MockProductsWorker()
        
        primaryProducts.nextWorker = nextProducts
        XCTAssertNotNil(primaryProducts.nextWorker)
    }
    
    // MARK: - Integration Tests
    
    func testProductsWithSystemsWorker() {
        let products = MockProductsWorker()
        let systems = MockSystemsWorker()
        
        products.wkrSystems = systems
        XCTAssertNotNil(products.wkrSystems)
        
        let expectation = self.expectation(description: "Products with systems")
        products.doLoadProducts { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Products Worker Implementation

private class MockProductsWorker: MockWorker, WKRPTCLProducts {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    var shouldFail = false
    
    override var nextWorker: DNSPTCLWorker? {
        get { return super.nextWorker as? WKRPTCLProducts }
        set { super.nextWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLProducts, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    
    func doLoadPricing(for product: DAOProduct, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkPricing?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                let pricing = DAOPricing()
                block?(.success(pricing))
            }
        }
    }

    func doLoadProduct(for id: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkProduct?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.notFound(field: "id", value: id, DNSCodeLocation(self))))
            } else {
                let product = DAOProduct()
                block?(.success(product))
            }
        }
    }

    func doLoadProduct(for id: String, and place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkProduct?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.notFound(field: "id", value: id, DNSCodeLocation(self))))
            } else {
                let product = DAOProduct()
                block?(.success(product))
            }
        }
    }

    func doLoadProducts(with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkAProduct?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                let products: [DAOProduct] = [DAOProduct(), DAOProduct()]
                block?(.success(products))
            }
        }
    }

    func doLoadProducts(for place: DAOPlace, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkAProduct?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                let products: [DAOProduct] = [DAOProduct(), DAOProduct()]
                block?(.success(products))
            }
        }
    }

    func doReact(with reaction: DNSReactionType, to product: DAOProduct, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                let meta = DNSMetadata()
                block?(.success(meta))
            }
        }
    }

    func doRemove(_ product: DAOProduct, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doUnreact(with reaction: DNSReactionType, to product: DAOProduct, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                let meta = DNSMetadata()
                block?(.success(meta))
            }
        }
    }

    func doUpdate(_ pricing: DAOPricing, for product: DAOProduct, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doUpdate(_ product: DAOProduct, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLProductsBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLProductsError.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    // MARK: - Shortcut Methods

    func doLoadPricing(for product: DAOProduct, with block: WKRPTCLProductsBlkPricing?) {
        doLoadPricing(for: product, with: nil, and: block)
    }

    func doLoadProduct(for id: String, with block: WKRPTCLProductsBlkProduct?) {
        doLoadProduct(for: id, with: nil, and: block)
    }

    func doLoadProduct(for id: String, and place: DAOPlace, with block: WKRPTCLProductsBlkProduct?) {
        doLoadProduct(for: id, and: place, with: nil, and: block)
    }

    func doLoadProducts(with block: WKRPTCLProductsBlkAProduct?) {
        doLoadProducts(with: nil, and: block)
    }

    func doLoadProducts(for place: DAOPlace, with block: WKRPTCLProductsBlkAProduct?) {
        doLoadProducts(for: place, with: nil, and: block)
    }

    func doReact(with reaction: DNSReactionType, to product: DAOProduct, with block: WKRPTCLProductsBlkMeta?) {
        doReact(with: reaction, to: product, with: nil, and: block)
    }

    func doRemove(_ product: DAOProduct, with block: WKRPTCLProductsBlkVoid?) {
        doRemove(product, with: nil, and: block)
    }

    func doUnreact(with reaction: DNSReactionType, to product: DAOProduct, with block: WKRPTCLProductsBlkMeta?) {
        doUnreact(with: reaction, to: product, with: nil, and: block)
    }

    func doUpdate(_ pricing: DAOPricing, for product: DAOProduct, with block: WKRPTCLProductsBlkVoid?) {
        doUpdate(pricing, for: product, with: nil, and: block)
    }

    func doUpdate(_ product: DAOProduct, with block: WKRPTCLProductsBlkVoid?) {
        doUpdate(product, with: nil, and: block)
    }
}

