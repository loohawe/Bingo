//
//  ShGit.swift
//  MogoAirport
//
//  Created by luhao on 09/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import PromiseKit

public class Shell: ShellExecutableProtocol {
    
    private var _allCommand: String
    private var _command: String
    private var _commandOptions: [String]
    
    private var _which: ShWhich
    private var _shell: ShellService
    
    init(command: String) {
        _allCommand = command
        let comdSep = _allCommand.components(separatedBy: " ")
        guard let coName = comdSep.first else {
            fatalError("命令错误")
        }
        _command = coName
        _commandOptions = Array.init(comdSep.dropFirst())
        
        _which = ShWhich(_command)
        _shell = ShellService(command: "", options: self._commandOptions, inDirectory: "/")
    }
    
    public func executeCommand(_ handle: @escaping (String, ShellError?) -> Void) {
        _which.executeCommand { [weak self] (commandPath, error) in
            guard let `self` = self else { return }
            if let error = error {
                handle("", error)
            } else {
                self._shell.command = commandPath
                self._shell.excuteCommand(handle)
            }
        }
    }
    
    public func execute() -> Promise<String> {
        
        return Promise.init(resolver: { (resolver) in
            
            _which.execute()
                .then({ [weak self] (commandPath) -> Promise<String> in
                    guard let `self` = self else { return Promise.value("") }
                    self._shell.command = commandPath
                    return self._shell.execute()
                    
                })
                .done({ (resultStr) in
                    resolver.fulfill(resultStr)
                })
                .catch({ (erroe) in
                    
                })
            
        })
    }
}
