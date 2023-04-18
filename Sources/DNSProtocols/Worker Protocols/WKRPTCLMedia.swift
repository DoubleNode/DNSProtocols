//
//  WKRPTCLMedia.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import PDFKit
import UIKit

// Protocol Return Types
public typealias WKRPTCLMediaRtnMedia = DAOMedia
public typealias WKRPTCLMediaRtnMeta = DNSMetadata
public typealias WKRPTCLMediaRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLMediaResMedia = Result<WKRPTCLMediaRtnMedia, Error>
public typealias WKRPTCLMediaResMeta = Result<WKRPTCLMediaRtnMeta, Error>
public typealias WKRPTCLMediaResVoid = Result<WKRPTCLMediaRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLMediaBlkMedia = (WKRPTCLMediaResMedia) -> Void
public typealias WKRPTCLMediaBlkMeta = (WKRPTCLMediaResMeta) -> Void
public typealias WKRPTCLMediaBlkVoid = (WKRPTCLMediaResVoid) -> Void

public protocol WKRPTCLMedia: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLMedia? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLMedia,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doReact(with reaction: DNSReactionType,
                 to media: DAOMedia,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLMediaBlkMeta?)
    func doRemove(_ media: DAOMedia,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLMediaBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to media: DAOMedia,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLMediaBlkMeta?)
    func doUpload(from fileUrl: URL,
                  to path: String,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLMediaBlkMedia?)
    func doUpload(_ image: UIImage,
                  to path: String,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLMediaBlkMedia?)
    func doUpload(_ pdfDocument: PDFDocument,
                  to path: String,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLMediaBlkMedia?)
    func doUpload(_ text: String,
                  to path: String,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLMediaBlkMedia?)

    // MARK: - Worker Logic (Shortcuts) -
    func doReact(with reaction: DNSReactionType,
                 to media: DAOMedia,
                 with block: WKRPTCLMediaBlkMeta?)
    func doRemove(_ media: DAOMedia,
                  with block: WKRPTCLMediaBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to media: DAOMedia,
                   with block: WKRPTCLMediaBlkMeta?)
    func doUpload(from fileUrl: URL,
                  to path: String,
                  with block: WKRPTCLMediaBlkMedia?)
    func doUpload(_ image: UIImage,
                  to path: String,
                  with block: WKRPTCLMediaBlkMedia?)
    func doUpload(_ pdfDocument: PDFDocument,
                  to path: String,
                  with block: WKRPTCLMediaBlkMedia?)
    func doUpload(_ text: String,
                  to path: String,
                  with block: WKRPTCLMediaBlkMedia?)
}
