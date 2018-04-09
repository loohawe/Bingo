//
//  ShellExecutableProtocol.swift
//  MogoAirport
//
//  Created by luhao on 09/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import PromiseKit

public protocol ShellExecutableProtocol {
    func execute() -> Promise<String>
}
