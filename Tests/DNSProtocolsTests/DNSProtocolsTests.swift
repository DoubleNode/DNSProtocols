//
//  DNSProtocolsTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
@testable import DNSProtocols

final class DNSProtocolsTests: XCTestCase {
    func testProtocolsImportSuccessful() {
        // Test that we can reference basic protocol types without initialization issues
        XCTAssertNotNil(WKRPTCLAnalytics.self, "WKRPTCLAnalytics protocol should be accessible")
        XCTAssertNotNil(WKRPTCLAuth.self, "WKRPTCLAuth protocol should be accessible")
    }

    static var allTests = [
        ("testProtocolsImportSuccessful", testProtocolsImportSuccessful),
    ]
}
