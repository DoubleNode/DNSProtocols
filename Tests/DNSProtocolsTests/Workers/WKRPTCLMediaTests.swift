//
//  WKRPTCLMediaTests.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocolsTests
//
//  Created by Darren Ehlers.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import Foundation
import PDFKit
import DNSCore
import DNSDataObjects
import DNSDataTypes
import DNSError
@testable import DNSProtocols

class WKRPTCLMediaTests: ProtocolTestBase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Protocol Existence Tests
    
    func testWKRPTCLMediaProtocolExists() {
        validateProtocolExists(WKRPTCLMedia.self)
    }
    
    func testWKRPTCLMediaInheritsFromWorkerBase() {
        let mockMedia = MockMediaWorker()
        validateProtocolConformance(mockMedia, conformsTo: WKRPTCLWorkerBase.self)
        validateProtocolConformance(mockMedia, conformsTo: WKRPTCLMedia.self)
    }
    
    // MARK: - Type Alias Tests
    
    func testMediaTypeAliases() {
        validateTypeAlias(WKRPTCLMediaRtnMedia.self, aliasName: "WKRPTCLMediaRtnMedia")
        validateTypeAlias(WKRPTCLMediaRtnMedia.self, aliasName: "WKRPTCLMediaRtnMedia")
        validateTypeAlias(WKRPTCLMediaRtnVoid.self, aliasName: "WKRPTCLMediaRtnVoid")
        validateTypeAlias(WKRPTCLMediaBlkMedia.self, aliasName: "WKRPTCLMediaBlkMedia")
        validateTypeAlias(WKRPTCLMediaBlkMedia.self, aliasName: "WKRPTCLMediaBlkMedia")
        validateTypeAlias(WKRPTCLMediaBlkVoid.self, aliasName: "WKRPTCLMediaBlkVoid")
    }
    
    // MARK: - Media Methods Tests
    
    func testUploadFromFileMethod() {
        let mockMedia = MockMediaWorker()
        let expectation = self.expectation(description: "Upload from file completion")
        let testURL = URL(fileURLWithPath: "/tmp/test.jpg")

        mockMedia.doUpload(from: testURL, to: "uploads/") { result in
            switch result {
            case .success(let media):
                XCTAssertNotNil(media, "Uploaded media should not be nil")
            case .failure(let error):
                XCTFail("Upload from file should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
    
    func testUploadImageMethod() {
        let mockMedia = MockMediaWorker()
        let expectation = self.expectation(description: "Upload image completion")
        let testImage = UIImage()

        mockMedia.doUpload(testImage, to: "uploads/") { result in
            switch result {
            case .success(let media):
                XCTAssertNotNil(media, "Uploaded media should not be nil")
            case .failure(let error):
                XCTFail("Upload image should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
    
    func testRemoveMediaMethod() {
        let mockMedia = MockMediaWorker()
        let expectation = self.expectation(description: "Remove media completion")
        let testMedia = DAOMedia()

        mockMedia.doRemove(testMedia) { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Remove media should succeed")
            case .failure(let error):
                XCTFail("Remove media should not fail: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Chain of Responsibility Tests
    
    func testMediaWorkerChaining() {
        let primaryMedia = MockMediaWorker()
        let nextMedia = MockMediaWorker()
        
        primaryMedia.nextWorker = nextMedia
        XCTAssertNotNil(primaryMedia.nextWorker)
    }
    
    // MARK: - Integration Tests
    
    func testMediaWithSystemsWorker() {
        let media = MockMediaWorker()
        let systems = MockSystemsWorker()
        
        media.wkrSystems = systems
        XCTAssertNotNil(media.wkrSystems)
        
        let expectation = self.expectation(description: "Media with systems")
        let testURL = URL(fileURLWithPath: "/tmp/test.jpg")
        media.doUpload(from: testURL, to: "uploads/") { result in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}

// MARK: - Mock Media Worker Implementation

private class MockMediaWorker: MockWorker, WKRPTCLMedia {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen = .whenError
    var shouldFail = false
    
    override var nextWorker: DNSPTCLWorker? {
        get { return super.nextWorker as? WKRPTCLMedia }
        set { super.nextWorker = newValue }
    }
    
    func register(nextWorker: WKRPTCLMedia, for callNextWhen: DNSPTCLWorker.Call.NextWhen) {
        self.nextWorker = nextWorker
    }
    
    func doReact(with reaction: DNSReactionType, to media: DAOMedia, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLMediaBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLMediaError.unknown(DNSCodeLocation(self))))
            } else {
                let meta = DNSMetadata()
                block?(.success(meta))
            }
        }
    }

    func doRemove(_ media: DAOMedia, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLMediaBlkVoid?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLMediaError.unknown(DNSCodeLocation(self))))
            } else {
                block?(.success(()))
            }
        }
    }

    func doUnreact(with reaction: DNSReactionType, to media: DAOMedia, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLMediaBlkMeta?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLMediaError.unknown(DNSCodeLocation(self))))
            } else {
                let meta = DNSMetadata()
                block?(.success(meta))
            }
        }
    }

    func doUpload(from fileUrl: URL, to path: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLMediaBlkMedia?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLMediaError.unknown(DNSCodeLocation(self))))
            } else {
                let media = DAOMedia()
                block?(.success(media))
            }
        }
    }

    func doUpload(_ image: UIImage, to path: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLMediaBlkMedia?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLMediaError.unknown(DNSCodeLocation(self))))
            } else {
                let media = DAOMedia()
                block?(.success(media))
            }
        }
    }

    func doUpload(_ pdfDocument: PDFDocument, to path: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLMediaBlkMedia?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLMediaError.unknown(DNSCodeLocation(self))))
            } else {
                let media = DAOMedia()
                block?(.success(media))
            }
        }
    }

    func doUpload(_ text: String, to path: String, with progress: DNSPTCLProgressBlock?, and block: WKRPTCLMediaBlkMedia?) {
        DispatchQueue.main.async {
            if self.shouldFail {
                block?(.failure(WKRPTCLMediaError.unknown(DNSCodeLocation(self))))
            } else {
                let media = DAOMedia()
                block?(.success(media))
            }
        }
    }

    // MARK: - Shortcut Methods

    func doReact(with reaction: DNSReactionType, to media: DAOMedia, with block: WKRPTCLMediaBlkMeta?) {
        doReact(with: reaction, to: media, with: nil, and: block)
    }

    func doRemove(_ media: DAOMedia, with block: WKRPTCLMediaBlkVoid?) {
        doRemove(media, with: nil, and: block)
    }

    func doUnreact(with reaction: DNSReactionType, to media: DAOMedia, with block: WKRPTCLMediaBlkMeta?) {
        doUnreact(with: reaction, to: media, with: nil, and: block)
    }

    func doUpload(from fileUrl: URL, to path: String, with block: WKRPTCLMediaBlkMedia?) {
        doUpload(from: fileUrl, to: path, with: nil, and: block)
    }

    func doUpload(_ image: UIImage, to path: String, with block: WKRPTCLMediaBlkMedia?) {
        doUpload(image, to: path, with: nil, and: block)
    }

    func doUpload(_ pdfDocument: PDFDocument, to path: String, with block: WKRPTCLMediaBlkMedia?) {
        doUpload(pdfDocument, to: path, with: nil, and: block)
    }

    func doUpload(_ text: String, to path: String, with block: WKRPTCLMediaBlkMedia?) {
        doUpload(text, to: path, with: nil, and: block)
    }
}

