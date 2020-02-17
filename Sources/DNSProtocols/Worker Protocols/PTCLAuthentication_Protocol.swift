//
//  PTCLAuthentication_Protocol.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import UIKit

public protocol PTCLAuthentication_AccessData {
}

public typealias PTCLAuthenticationBlockVoidBoolError = (Bool, Error?) -> Void
public typealias PTCLAuthenticationBlockVoidBoolAccessDataError = (Bool, PTCLAuthentication_AccessData, Error?) -> Void

public protocol PTCLAuthentication_Protocol: PTCLBase_Protocol {
    var nextWorker: PTCLAuthentication_Protocol? { get }

    init()
    init(nextWorker: PTCLAuthentication_Protocol)

    // MARK: - Business Logic / Single Item CRUD
    func doCheckAuthentication(using parameters: [String: Any],
                               with progress: PTCLProgressBlock?,
                               and block: PTCLAuthenticationBlockVoidBoolAccessDataError) throws
    func doSignIn(from username: String?,
                  and password: String?,
                  using parameters: [String: Any],
                  with progress: PTCLProgressBlock?,
                  and block: @escaping PTCLAuthenticationBlockVoidBoolAccessDataError) throws
    func doSignOut(using parameters: [String: Any],
                   with progress: PTCLProgressBlock?,
                   and block: @escaping PTCLAuthenticationBlockVoidBoolError) throws
}
