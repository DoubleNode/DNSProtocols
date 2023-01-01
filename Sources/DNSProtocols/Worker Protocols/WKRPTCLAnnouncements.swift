//
//  WKRPTCLAnnouncements.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLAnnouncementsRtnAAnnouncement = [DAOAnnouncement]
public typealias WKRPTCLAnnouncementsRtnAnnouncement = DAOAnnouncement
public typealias WKRPTCLAnnouncementsRtnAAnnouncementPlace = ([DAOAnnouncement], [DAOPlace])
public typealias WKRPTCLAnnouncementsRtnMeta = DNSMetadata
public typealias WKRPTCLAnnouncementsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAnnouncementsResAAnnouncement = Result<WKRPTCLAnnouncementsRtnAAnnouncement, Error>
public typealias WKRPTCLAnnouncementsResAnnouncement = Result<WKRPTCLAnnouncementsRtnAnnouncement, Error>
public typealias WKRPTCLAnnouncementsResAAnnouncementPlace = Result<WKRPTCLAnnouncementsRtnAAnnouncementPlace, Error>
public typealias WKRPTCLAnnouncementsResMeta = Result<WKRPTCLAnnouncementsRtnMeta, Error>
public typealias WKRPTCLAnnouncementsResVoid = Result<WKRPTCLAnnouncementsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLAnnouncementsBlkAAnnouncement = (WKRPTCLAnnouncementsResAAnnouncement) -> Void
public typealias WKRPTCLAnnouncementsBlkAnnouncement = (WKRPTCLAnnouncementsResAnnouncement) -> Void
public typealias WKRPTCLAnnouncementsBlkAAnnouncementPlace = (WKRPTCLAnnouncementsResAAnnouncementPlace) -> Void
public typealias WKRPTCLAnnouncementsBlkMeta = (WKRPTCLAnnouncementsResMeta) -> Void
public typealias WKRPTCLAnnouncementsBlkVoid = (WKRPTCLAnnouncementsResVoid) -> Void

public protocol WKRPTCLAnnouncements: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLAnnouncements? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLAnnouncements,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadAnnouncements(with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLAnnouncementsBlkAAnnouncement?)
    func doLoadAnnouncements(for place: DAOPlace,
                             with progress: DNSPTCLProgressBlock?,
                             and block: WKRPTCLAnnouncementsBlkAAnnouncement?)
    func doLoadCurrentAnnouncements(with progress: DNSPTCLProgressBlock?,
                                    and block: WKRPTCLAnnouncementsBlkAAnnouncementPlace?)
    func doReact(with reaction: DNSReactionType,
                 to announcement: DAOAnnouncement,
                 for place: DAOPlace,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLAnnouncementsBlkMeta?)
    func doReact(with reaction: DNSReactionType,
                 to announcement: DAOAnnouncement,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLAnnouncementsBlkMeta?)
    func doRemove(_ announcement: DAOAnnouncement,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAnnouncementsBlkVoid?)
    func doRemove(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAnnouncementsBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to announcement: DAOAnnouncement,
                   for place: DAOPlace,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLAnnouncementsBlkMeta?)
    func doUnreact(with reaction: DNSReactionType,
                   to announcement: DAOAnnouncement,
                   with progress: DNSPTCLProgressBlock?,
                   and block: WKRPTCLAnnouncementsBlkMeta?)
    func doUpdate(_ announcement: DAOAnnouncement,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAnnouncementsBlkVoid?)
    func doUpdate(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAnnouncementsBlkVoid?)
    func doView(_ announcement: DAOAnnouncement,
                with progress: DNSPTCLProgressBlock?,
                and block: WKRPTCLAnnouncementsBlkMeta?)
    func doView(_ announcement: DAOAnnouncement,
                for place: DAOPlace,
                with progress: DNSPTCLProgressBlock?,
                and block: WKRPTCLAnnouncementsBlkMeta?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadAnnouncements(with block: WKRPTCLAnnouncementsBlkAAnnouncement?)
    func doLoadAnnouncements(for place: DAOPlace,
                             with block: WKRPTCLAnnouncementsBlkAAnnouncement?)
    func doLoadCurrentAnnouncements(with block: WKRPTCLAnnouncementsBlkAAnnouncementPlace?)
    func doReact(with reaction: DNSReactionType,
                 to announcement: DAOAnnouncement,
                 for place: DAOPlace,
                 with block: WKRPTCLAnnouncementsBlkMeta?)
    func doReact(with reaction: DNSReactionType,
                 to announcement: DAOAnnouncement,
                 with block: WKRPTCLAnnouncementsBlkMeta?)
    func doRemove(_ announcement: DAOAnnouncement,
                  with block: WKRPTCLAnnouncementsBlkVoid?)
    func doRemove(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with block: WKRPTCLAnnouncementsBlkVoid?)
    func doUnreact(with reaction: DNSReactionType,
                   to announcement: DAOAnnouncement,
                   for place: DAOPlace,
                   with block: WKRPTCLAnnouncementsBlkMeta?)
    func doUnreact(with reaction: DNSReactionType,
                   to announcement: DAOAnnouncement,
                   with block: WKRPTCLAnnouncementsBlkMeta?)
    func doUpdate(_ announcement: DAOAnnouncement,
                  with block: WKRPTCLAnnouncementsBlkVoid?)
    func doUpdate(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with block: WKRPTCLAnnouncementsBlkVoid?)
    func doView(_ announcement: DAOAnnouncement,
                with block: WKRPTCLAnnouncementsBlkMeta?)
    func doView(_ announcement: DAOAnnouncement,
                for place: DAOPlace,
                with block: WKRPTCLAnnouncementsBlkMeta?)
}
