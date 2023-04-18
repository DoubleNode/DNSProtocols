//
//  WKRPTCLChats.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLChatsRtnChat = DAOChat
public typealias WKRPTCLChatsRtnAChatMessage = [DAOChatMessage]
public typealias WKRPTCLChatsRtnMeta = DNSMetadata
public typealias WKRPTCLChatsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLChatsResChat = Result<WKRPTCLChatsRtnChat, Error>
public typealias WKRPTCLChatsResAChatMessage = Result<WKRPTCLChatsRtnAChatMessage, Error>
public typealias WKRPTCLChatsResMeta = Result<WKRPTCLChatsRtnMeta, Error>
public typealias WKRPTCLChatsResVoid = Result<WKRPTCLChatsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLChatsBlkChat = (WKRPTCLChatsResChat) -> Void
public typealias WKRPTCLChatsBlkAChatMessage = (WKRPTCLChatsResAChatMessage) -> Void
public typealias WKRPTCLChatsBlkMeta = (WKRPTCLChatsResMeta) -> Void
public typealias WKRPTCLChatsBlkVoid = (WKRPTCLChatsResVoid) -> Void

public protocol WKRPTCLChats: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLChats? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLChats,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadChat(for id: String,
                    with progress: DNSPTCLProgressBlock?,
                    and block: WKRPTCLChatsBlkChat?)
    func doLoadMessages(for chat: DAOChat,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLChatsBlkAChatMessage?)
    func doReact(with reaction: DNSReactionType,
                 to chat: DAOChat,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLChatsBlkMeta?)
    func doRemove(_ message: DAOChatMessage,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLChatsBlkVoid?)
    func doUpdate(_ message: DAOChatMessage,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLChatsBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadChat(for id: String,
                    with block: WKRPTCLChatsBlkChat?)
    func doLoadMessages(for chat: DAOChat,
                        with block: WKRPTCLChatsBlkAChatMessage?)
    func doReact(with reaction: DNSReactionType,
                 to chat: DAOChat,
                 with block: WKRPTCLChatsBlkMeta?)
    func doRemove(_ message: DAOChatMessage,
                  with block: WKRPTCLChatsBlkVoid?)
    func doUpdate(_ message: DAOChatMessage,
                  with block: WKRPTCLChatsBlkVoid?)
}
