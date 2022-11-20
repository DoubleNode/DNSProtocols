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
public typealias WKRPTCLAnnouncementsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLAnnouncementsResAAnnouncement = Result<WKRPTCLAnnouncementsRtnAAnnouncement, Error>
public typealias WKRPTCLAnnouncementsResAnnouncement = Result<WKRPTCLAnnouncementsRtnAnnouncement, Error>
public typealias WKRPTCLAnnouncementsResVoid = Result<WKRPTCLAnnouncementsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLAnnouncementsBlkAAnnouncement = (WKRPTCLAnnouncementsResAAnnouncement) -> Void
public typealias WKRPTCLAnnouncementsBlkAnnouncement = (WKRPTCLAnnouncementsResAnnouncement) -> Void
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
    func doRemove(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAnnouncementsBlkVoid?)
    func doUpdate(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLAnnouncementsBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadAnnouncements(with block: WKRPTCLAnnouncementsBlkAAnnouncement?)
    func doLoadAnnouncements(for place: DAOPlace,
                             with block: WKRPTCLAnnouncementsBlkAAnnouncement?)
    func doRemove(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with block: WKRPTCLAnnouncementsBlkVoid?)
    func doUpdate(_ announcement: DAOAnnouncement,
                  for place: DAOPlace,
                  with block: WKRPTCLAnnouncementsBlkVoid?)
}
