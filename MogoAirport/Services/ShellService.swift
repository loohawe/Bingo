//
//  ShellService.swift
//  MogoAirport
//
//  Created by luhao on 08/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import PromiseKit

public struct ShellError: Error {
    var describ: String
}

public class ShellService: ShellExecutableProtocol {
    
    public var command: String
    public var options: [String]
    public var directory: String
    
    public init(command aCommand: String, options aOptions: [String], inDirectory dic: String) {
        command = aCommand
        options = aOptions
        directory = dic
    }
    
    public func excuteCommand(_ finish: @escaping (String, ShellError?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            
            // Create a Task instance (was NSTask on swift pre 3.0)
            
            let task = Process()
            
            // Set the task parameters
            // /Users/luhao
            // 工作目录
            task.currentDirectoryURL = URL(fileURLWithPath: self.directory)
            // /Applications/Xcode.app/Contents/Developer/usr/bin/git
            // /usr/bin/which
            // 任务命令
            task.executableURL = URL(fileURLWithPath: self.command, isDirectory: false)
            
            let environment = ProcessInfo.processInfo.environment
            task.environment = environment
            
            //let commit = self.entity.projectLoc.appendingPathComponent("commit.sh").path
            // 命令参数
            task.arguments = self.options
            
            // Create a Pipe and make the task
            // put all the output there
            let stdOut = Pipe()
            task.standardOutput = stdOut
            let stdErr = Pipe()
            task.standardError = stdErr
            
            let handler = { (file: FileHandle!) -> Void in
                let data = file.availableData
                guard let output = String.init(data: data, encoding: String.Encoding.utf8) else {
                    return
                }
                
                if output.isEmpty {
                    return
                }
                
                finish(output, nil)
            }
            
            let errorHandler = { (file: FileHandle!) -> Void in
                
                let data = file.availableData
                guard let output = String.init(data: data, encoding: String.Encoding.utf8) else {
                    return
                }
                
                if output.isEmpty {
                    return
                }
                
                finish("", ShellError(describ: "Shell 命令出错: \(output)"))
            }
            
            stdOut.fileHandleForReading.readabilityHandler = handler
            stdErr.fileHandleForReading.readabilityHandler = errorHandler
            
            task.terminationHandler = { (aTash: Process?) in
                stdOut.fileHandleForReading.readabilityHandler = nil
                stdErr.fileHandleForReading.readabilityHandler = nil
            }
            
            // Launch the task
            do {
                try task.run()
            } catch (let error) {
                fatalError("shell 命令出错: \(error)")
            }
        }
    }
    
    public func execute() -> Promise<String> {
        return Promise { resolver in
            excuteCommand({ (result, error) in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(result)
                }
            })
        }
    }
}
