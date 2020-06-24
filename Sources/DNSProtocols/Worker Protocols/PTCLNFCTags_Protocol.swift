//
//  PTCLNFCTags_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2020 - 2016 DoubleNode.com. All rights reserved.
//

#if !os(macOS)
import CoreNFC
#endif
import Foundation

public enum PTCLNFCTagsError: Error
{
    case notSupported(domain: String, file: String, line: String, method: String)
    case system(domain: String, file: String, line: String, method: String)
    case timeout(domain: String, file: String, line: String, method: String)
}

extension PTCLNFCTagsError: DNSError {
    public var nsError: NSError! {
        switch self {
        case .notSupported(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain,
                                            "DNSFile": file,
                                            "DNSLine": line,
                                            "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)

        case .system(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain,
                                            "DNSFile": file,
                                            "DNSLine": line,
                                            "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)

        case .timeout(let domain, let file, let line, let method):
            let userInfo: [String : Any] = ["DNSDomain": domain,
                                            "DNSFile": file,
                                            "DNSLine": line,
                                            "DNSMethod": method,
                                            NSLocalizedDescriptionKey: self.errorDescription ?? "Unknown Error"]
            return NSError.init(domain: domain, code: -9999, userInfo: userInfo)
        }
    }
    public var errorDescription: String? {
        switch self {
        case .notSupported(let domain, let file, let line, let method):
            return NSLocalizedString(
                "Your system doesn't support NFC Tags (\(domain):\(file):\(line):\(method))",
                comment: ""
            )

        case .system(let domain, let file, let line, let method):
            return NSLocalizedString(
                "CoreNFC System Error (\(domain):\(file):\(line):\(method))",
                comment: ""
            )

        case .timeout(let domain, let file, let line, let method):
            return NSLocalizedString(
                "NFC Reader Timeout Error (\(domain):\(file):\(line):\(method))",
                comment: ""
            )
        }
    }
}

// (object: Any?, error: Error?)
public typealias PTCLNFCTagsBlockVoidArrayNFCNDEFMessageDNSError = ([NFCNDEFMessage], DNSError?) -> Void

public protocol PTCLNFCTags_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLNFCTags_Protocol? { get }

    init()
    init(nextWorker: PTCLNFCTags_Protocol)

    // MARK: - Business Logic / Single Item CRUD
    func doScanTags(for key: String,
                    with progress: PTCLProgressBlock?,
                    and block: PTCLNFCTagsBlockVoidArrayNFCNDEFMessageDNSError?) throws
}
