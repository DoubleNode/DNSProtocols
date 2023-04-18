//
//  WKRPTCLSections.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers.
//  Copyright © 2022 - 2016 DoubleNode.com. All rights reserved.
//

import Combine
import DNSDataObjects
import Foundation

// Protocol Return Types
public typealias WKRPTCLSectionsRtnMeta = DNSMetadata
public typealias WKRPTCLSectionsRtnAPlace = [DAOPlace]
public typealias WKRPTCLSectionsRtnASection = [DAOSection]
public typealias WKRPTCLSectionsRtnSection = DAOSection
public typealias WKRPTCLSectionsRtnVoid = Void

// Protocol Result Types
public typealias WKRPTCLSectionsResMeta = Result<WKRPTCLSectionsRtnMeta, Error>
public typealias WKRPTCLSectionsResAPlace = Result<WKRPTCLSectionsRtnAPlace, Error>
public typealias WKRPTCLSectionsResASection = Result<WKRPTCLSectionsRtnASection, Error>
public typealias WKRPTCLSectionsResSection = Result<WKRPTCLSectionsRtnSection, Error>
public typealias WKRPTCLSectionsResVoid = Result<WKRPTCLSectionsRtnVoid, Error>

// Protocol Block Types
public typealias WKRPTCLSectionsBlkMeta = (WKRPTCLSectionsResMeta) -> Void
public typealias WKRPTCLSectionsBlkAPlace = (WKRPTCLSectionsResAPlace) -> Void
public typealias WKRPTCLSectionsBlkASection = (WKRPTCLSectionsResASection) -> Void
public typealias WKRPTCLSectionsBlkSection = (WKRPTCLSectionsResSection) -> Void
public typealias WKRPTCLSectionsBlkVoid = (WKRPTCLSectionsResVoid) -> Void

public protocol WKRPTCLSections: WKRPTCLWorkerBase {
    var callNextWhen: DNSPTCLWorker.Call.NextWhen { get }
    var nextWorker: WKRPTCLSections? { get }
    var wkrSystems: WKRPTCLSystems? { get }

    init()
    func register(nextWorker: WKRPTCLSections,
                  for callNextWhen: DNSPTCLWorker.Call.NextWhen)

    // MARK: - Worker Logic (Public) -
    func doLoadChildren(for section: DAOSection,
                        with progress: DNSPTCLProgressBlock?,
                        and block: WKRPTCLSectionsBlkASection?)
    func doLoadParent(for section: DAOSection,
                      with progress: DNSPTCLProgressBlock?,
                      and block: WKRPTCLSectionsBlkSection?)
    func doLoadSection(for id: String,
                       with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSectionsBlkSection?)
    func doLoadSections(with progress: DNSPTCLProgressBlock?,
                       and block: WKRPTCLSectionsBlkASection?)
    func doReact(with reaction: DNSReactionType,
                 to section: DAOSection,
                 with progress: DNSPTCLProgressBlock?,
                 and block: WKRPTCLSectionsBlkMeta?)
    func doUpdate(_ section: DAOSection,
                  with progress: DNSPTCLProgressBlock?,
                  and block: WKRPTCLSectionsBlkVoid?)

    // MARK: - Worker Logic (Shortcuts) -
    func doLoadChildren(for section: DAOSection,
                        with block: WKRPTCLSectionsBlkASection?)
    func doLoadParent(for section: DAOSection,
                      with block: WKRPTCLSectionsBlkSection?)
    func doLoadSection(for id: String,
                       with block: WKRPTCLSectionsBlkSection?)
    func doLoadSections(with block: WKRPTCLSectionsBlkASection?)
    func doReact(with reaction: DNSReactionType,
                 to section: DAOSection,
                 with block: WKRPTCLSectionsBlkMeta?)
    func doUpdate(_ section: DAOSection,
                  with block: WKRPTCLSectionsBlkVoid?)
}
