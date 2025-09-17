//
//  WKRPTCLAuthAsync.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Claude Code Assistant for async/await migration.
//  Copyright © 2025 - 2016 DoubleNode.com. All rights reserved.
//

import DNSCore
import DNSDataContracts
import Foundation

// MARK: - Async Protocol Variants

/// Async version of WKRPTCLAuth for modern concurrency
public protocol WKRPTCLAuthAsync: WKRPTCLAuth {
    
    // MARK: - Async Worker Logic (Public) -
    
    /// Check authentication status asynchronously
    func doCheckAuth(using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolBoolAccessData
    
    /// Link authentication credentials asynchronously
    func doLinkAuth(from username: String, 
                    and password: String, 
                    using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolAccessData
    
    /// Start password reset flow asynchronously
    func doPasswordResetStart(from username: String?, 
                              using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnVoid
    
    /// Sign in user asynchronously
    func doSignIn(from username: String?, 
                  and password: String?, 
                  using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolAccessData
    
    /// Sign out user asynchronously
    func doSignOut(using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnVoid
    
    /// Sign up user asynchronously
    func doSignUp(from user: (any DAOUserProtocol)?, 
                  and password: String?, 
                  using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolAccessData
}

// MARK: - Default Async Implementation Bridge

/// Provides default async implementations that bridge to existing callback-based methods
extension WKRPTCLAuthAsync {
    
    public func doCheckAuth(using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolBoolAccessData {
        return try await withCheckedThrowingContinuation { continuation in
            doCheckAuth(using: parameters, with: nil) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func doLinkAuth(from username: String, 
                           and password: String, 
                           using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolAccessData {
        return try await withCheckedThrowingContinuation { continuation in
            doLinkAuth(from: username, and: password, using: parameters) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func doPasswordResetStart(from username: String?, 
                                     using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            doPasswordResetStart(from: username, using: parameters) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func doSignIn(from username: String?, 
                         and password: String?, 
                         using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolAccessData {
        return try await withCheckedThrowingContinuation { continuation in
            doSignIn(from: username, and: password, using: parameters) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func doSignOut(using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnVoid {
        return try await withCheckedThrowingContinuation { continuation in
            doSignOut(using: parameters) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func doSignUp(from user: (any DAOUserProtocol)?, 
                         and password: String?, 
                         using parameters: DNSDataDictionary) async throws -> WKRPTCLAuthRtnBoolAccessData {
        return try await withCheckedThrowingContinuation { continuation in
            doSignUp(from: user, and: password, using: parameters) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Async Convenience Methods

extension WKRPTCLAuthAsync {
    
    /// Sign in with username and password (convenience method)
    @discardableResult
    func signIn(username: String, password: String, parameters: DNSDataDictionary = [:]) async throws -> (success: Bool, accessData: WKRPTCLAuthAccessData) {
        let result = try await doSignIn(from: username, and: password, using: parameters)
        return (success: result.0, accessData: result.1)
    }
    
    /// Sign up new user (convenience method)
    @discardableResult
    func signUp(user: any DAOUserProtocol, password: String, parameters: DNSDataDictionary = [:]) async throws -> (success: Bool, accessData: WKRPTCLAuthAccessData) {
        let result = try await doSignUp(from: user, and: password, using: parameters)
        return (success: result.0, accessData: result.1)
    }
    
    /// Sign out current user (convenience method)
    func signOut(parameters: DNSDataDictionary = [:]) async throws {
        try await doSignOut(using: parameters)
    }
    
    /// Check if user is authenticated (convenience method)
    @discardableResult
    func isAuthenticated(parameters: DNSDataDictionary = [:]) async throws -> (authenticated: Bool, valid: Bool, accessData: WKRPTCLAuthAccessData) {
        let result = try await doCheckAuth(using: parameters)
        return (authenticated: result.0, valid: result.1, accessData: result.2)
    }
    
    /// Reset password (convenience method)
    func resetPassword(for username: String, parameters: DNSDataDictionary = [:]) async throws {
        try await doPasswordResetStart(from: username, using: parameters)
    }
    
    /// Link additional authentication credentials (convenience method)
    @discardableResult
    func linkCredentials(username: String, password: String, parameters: DNSDataDictionary = [:]) async throws -> (success: Bool, accessData: WKRPTCLAuthAccessData) {
        let result = try await doLinkAuth(from: username, and: password, using: parameters)
        return (success: result.0, accessData: result.1)
    }
}

// MARK: - Safe Authentication Operations

extension WKRPTCLAuthAsync {
    
    /// Safe authentication check that won't throw (returns false on error)
    func safeIsAuthenticated(parameters: DNSDataDictionary = [:]) async -> Bool {
        do {
            let result = try await doCheckAuth(using: parameters)
            return result.0 && result.1 // authenticated AND valid
        } catch {
            debugPrint("Authentication check failed: \(error)")
            return false
        }
    }
    
    /// Safe sign in that returns optional success
    func safeSignIn(username: String, password: String, parameters: DNSDataDictionary = [:]) async -> WKRPTCLAuthAccessData? {
        do {
            let result = try await doSignIn(from: username, and: password, using: parameters)
            return result.0 ? result.1 : nil // Return access data only if successful
        } catch {
            debugPrint("Sign in failed: \(error)")
            return nil
        }
    }
    
    /// Safe sign out that won't throw
    func safeSignOut(parameters: DNSDataDictionary = [:]) async {
        do {
            try await doSignOut(using: parameters)
        } catch {
            debugPrint("Sign out failed: \(error)")
        }
    }
}
