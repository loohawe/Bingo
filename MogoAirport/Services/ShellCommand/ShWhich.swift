//
//  ShWhich.swift
//  MogoAirport
//
//  Created by luhao on 09/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import PromiseKit

public class ShWhich: ShellExecutableProtocol {
    
    private let _command: String
    private let _shell: ShellService
    
    init(_ command: String) {
        _command = command
        _shell = ShellService(command: "/usr/bin/which", options: ["-a", _command], inDirectory: "/")
    }
    
    public func executeCommand(_ handle: @escaping (String, ShellError?) -> Void) {
        _shell.excuteCommand { [weak self] (path, error) in
            guard let `self` = self else { return }
            if let error = error {
                handle("", error)
            } else {
                for item in path.components(separatedBy: "\n") {
                    if item.hasPrefix("/") && item.contains(self._command) {
                        handle(item, nil)
                        return
                    }
                }
                
                handle("", ShellError(describ: "找不到 \(self._command) 命令"))
            }
        }
    }
    
    public func execute() -> Promise<String> {
        return Promise.init(resolver: { [weak self] (resolver) in
            self?.executeCommand({ (str, error) in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(str)
                }
            })
        })
    }
}
