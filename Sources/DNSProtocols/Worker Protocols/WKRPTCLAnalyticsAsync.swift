//
//  WKRPTCLAnalyticsAsync.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Claude Code Assistant for async/await migration.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSError
import Foundation

// MARK: - Async Protocol Variants

/// Async version of WKRPTCLAnalytics for modern concurrency
public protocol WKRPTCLAnalyticsAsync: WKRPTCLAnalytics {
    
    // MARK: - Auto-Track Async Methods
    func doAutoTrack(class: String, method: String) async throws -> WKRPTCLAnalyticsRtnVoid
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    
    // MARK: - Group Async Methods
    func doGroup(groupId: String) async throws -> WKRPTCLAnalyticsRtnVoid
    func doGroup(groupId: String, traits: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    
    // MARK: - Identify Async Methods
    func doIdentify(userId: String) async throws -> WKRPTCLAnalyticsRtnVoid
    func doIdentify(userId: String, traits: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    
    // MARK: - Screen Async Methods
    func doScreen(screenTitle: String) async throws -> WKRPTCLAnalyticsRtnVoid
    func doScreen(screenTitle: String, properties: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    
    // MARK: - Track Async Methods
    func doTrack(event: WKRPTCLAnalytics.Events) async throws -> WKRPTCLAnalyticsRtnVoid
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
    func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid
}

// MARK: - Default Async Implementation Bridge

/// Provides default async implementations that bridge to existing sync methods
extension WKRPTCLAnalyticsAsync {
    
    // MARK: - Auto-Track Bridge Methods
    public func doAutoTrack(class: String, method: String) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doAutoTrack(class: `class`, method: method)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doAutoTrack(class: `class`, method: method, properties: properties)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doAutoTrack(class: `class`, method: method, properties: properties, options: options)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Group Bridge Methods
    public func doGroup(groupId: String) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doGroup(groupId: groupId)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doGroup(groupId: String, traits: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doGroup(groupId: groupId, traits: traits)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doGroup(groupId: String, traits: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doGroup(groupId: groupId, traits: traits, options: options)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Identify Bridge Methods
    public func doIdentify(userId: String) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doIdentify(userId: userId)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doIdentify(userId: String, traits: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doIdentify(userId: userId, traits: traits)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doIdentify(userId: String, traits: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doIdentify(userId: userId, traits: traits, options: options)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Screen Bridge Methods
    public func doScreen(screenTitle: String) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doScreen(screenTitle: screenTitle)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doScreen(screenTitle: String, properties: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doScreen(screenTitle: screenTitle, properties: properties)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doScreen(screenTitle: String, properties: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doScreen(screenTitle: screenTitle, properties: properties, options: options)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Track Bridge Methods
    public func doTrack(event: WKRPTCLAnalytics.Events) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doTrack(event: event)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doTrack(event: event, properties: properties)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
    
    public func doTrack(event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary, options: DNSDataDictionary) async throws -> WKRPTCLAnalyticsRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            let result = self.doTrack(event: event, properties: properties, options: options)
            switch result {
            case .success:
                continuation.resume(returning: ())
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}

// MARK: - Reverse Bridge: Sync from Async

/// Extension to provide sync methods that call async versions (for gradual migration)
extension WKRPTCLAnalyticsAsync {
    
    // MARK: - Auto-Track Sync Bridge
    @discardableResult
    public func doAutoTrack(class: String, method: String) -> WKRPTCLAnalyticsResVoid {
        var result: WKRPTCLAnalyticsResVoid = .failure(DNSError.Analytics.unknown(.protocols(self)))
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                let value: WKRPTCLAnalyticsRtnVoid = try await self.doAutoTrack(class: `class`, method: method)
                result = .success(value)
            } catch {
                result = .failure(error)
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
    
    @discardableResult
    public func doAutoTrack(class: String, method: String, properties: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        var result: WKRPTCLAnalyticsResVoid = .failure(DNSError.Analytics.unknown(.protocols(self)))
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                let value: WKRPTCLAnalyticsRtnVoid = try await self.doAutoTrack(class: `class`, method: method, properties: properties)
                result = .success(value)
            } catch {
                result = .failure(error)
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
    
    @discardableResult
    public func doAutoTrack(class: String, method: String, properties: DNSDataDictionary, options: DNSDataDictionary) -> WKRPTCLAnalyticsResVoid {
        var result: WKRPTCLAnalyticsResVoid = .failure(DNSError.Analytics.unknown(.protocols(self)))
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            do {
                let value: WKRPTCLAnalyticsRtnVoid = try await self.doAutoTrack(class: `class`, method: method, properties: properties, options: options)
                result = .success(value)
            } catch {
                result = .failure(error)
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
}

// MARK: - Async Convenience Methods

extension WKRPTCLAnalyticsAsync {
    /// Track screen view with convenient async syntax
    func trackScreen(_ screenTitle: String, properties: DNSDataDictionary = [:]) async {
        do {
            try await doScreen(screenTitle: screenTitle, properties: properties)
        } catch {
            // Log error but don't throw - analytics shouldn't crash the app
            debugPrint("Analytics screen tracking failed: \(error)")
        }
    }
    
    /// Track event with convenient async syntax
    func trackEvent(_ event: WKRPTCLAnalytics.Events, properties: DNSDataDictionary = [:]) async {
        do {
            try await doTrack(event: event, properties: properties)
        } catch {
            // Log error but don't throw - analytics shouldn't crash the app
            debugPrint("Analytics event tracking failed: \(error)")
        }
    }
    
    /// Identify user with convenient async syntax
    func identifyUser(_ userId: String, traits: DNSDataDictionary = [:]) async {
        do {
            try await doIdentify(userId: userId, traits: traits)
        } catch {
            // Log error but don't throw - analytics shouldn't crash the app
            debugPrint("Analytics user identification failed: \(error)")
        }
    }
}

