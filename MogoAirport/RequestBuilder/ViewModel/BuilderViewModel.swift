//
//  BuilderViewModel.swift
//  MogoAirport
//
//  Created by luhao on 06/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Cocoa
import RxSwift

fileprivate let projectName = "MGRenter_iOS_ApiWings"
fileprivate let partnerProjectName = "MGPartner_iOS_ApiWings"
fileprivate let hatNameTextFieldTag = 1000
fileprivate let pathTextFieldTag = 1001

class BuilderViewModel: NSObject
{
    // MARK: Property Public
    var entity: BuilderEntity
    
    var locSubject: PublishSubject<URL> {
        get {
            return entity.locSubject
        }
    }
    
    var fileService: FileService
    var fileRender: FileRenderService
    
    var paramEntityList: () -> [ParamEntity] = { [] }
    
    init(entity aEntity: BuilderEntity) {
        entity = aEntity
        fileService = FileService(entity: entity)
        fileRender = FileRenderService(entity: entity)
    }
}

// MARK: Delegate

extension BuilderViewModel: NSTextFieldDelegate
{
    override func controlTextDidChange(_ obj: Notification)
    {
        if let textField = obj.object as? NSTextField {
            if textField.tag == hatNameTextFieldTag {
                entity.hatName = textField.stringValue
            } else if textField.tag == pathTextFieldTag {
                entity.path = textField.stringValue
            }
        }
    }
}

// MARK: Method Public

extension BuilderViewModel
{
    public func resetEntity(_ aEntity: BuilderEntity) {
        entity = aEntity
        fileService.entity = entity
        fileRender.entity = entity
    }
    
    func chooseProject(_ handle: @escaping (Bool, String) -> Void)
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin {
            [weak openPanel] (result) in
            guard let `openPanel` = openPanel else { return }
            
            if result.rawValue == NSFileHandlingPanelOKButton {
                guard let location = openPanel.url else { return }
                
                if location.lastPathComponent == projectName || location.lastPathComponent == partnerProjectName {
                    self.entity.projectLoc = location
                    handle(true, location.path)
                } else {
                    handle(false, "")
                }
            }
        }
    }
    
    func showStupidAlert(in view: NSView)
    {
        guard let window = view.window else {
            return
        }
        
        let alert = NSAlert()
        alert.addButton(withTitle: "OK, I`m stupid")
        alert.messageText = "You must open project named: MGRenter_iOS_ApiWings"
        alert.alertStyle = .warning
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
    
    func generatorFiles()
    {
        entity.wingParamsString = parametersStringDes()
        entity.requestPropertyDes = requestPropertyListDes()
        entity.assignProperty = assignPropertyListDes()
        entity.requestInitString = requestInitStringDes()
        entity.paramsContentString = paramContentStringDes()
        
        do {
            let subpod = try fileRender.rendSubpodFile()
            try fileService.addPodSubspec(subpod)
            
            let wingContent = try fileRender.rendWingFile()
            print(wingContent)
            try fileService.creatWingFile(wingContent)
            
            let requestContent = try fileRender.rendWingRequestFile()
            print(requestContent)
            try fileService.creatWingRequestFile(requestContent)
            
            let mockContent = try fileRender.rendMockPlistFile()
            try fileService.creatMockPlistFile(mockContent)
            
        } catch let error {
            print(error)
        }
    }
}

// MARK: Method Private

extension BuilderViewModel
{
    func excuteUpdateCommand(_ finish: @escaping (String) -> Void)
    {
        DispatchQueue.global(qos: .default).async {
            // Create a Task instance (was NSTask on swift pre 3.0)
            let task = Process()
            
            // Set the task parameters
            task.launchPath = "/bin/sh"
            task.currentDirectoryPath = self.entity.projectLoc.path
            let environment = ProcessInfo.processInfo.environment
            task.environment = environment
            let commit = self.entity.projectLoc.appendingPathComponent("commit.sh").path
            task.arguments = [commit]
            
            // Create a Pipe and make the task
            // put all the output there
            let pipe = Pipe()
            task.standardOutput = pipe
            
            // Launch the task
            task.launch()
            
            // Get the data
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            
            pipe.fileHandleForReading.readInBackgroundAndNotify()
            
            let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            
            DispatchQueue.main.async {
                
                finish(output! as String)
                
                print(output!)
            }
        }
    }
    
    func parametersStringDes() -> String
    {
        var des = ""
        let paramEntitys = paramEntityList()
        paramEntitys.enumerated().forEach { (offset, entity) in
            des.append("\(entity.name): \(typeDes(entity.type))")
            if offset != paramEntitys.count - 1{
                des.append(", ")
            }
        }
        return des
    }
    
    func requestInitStringDes() -> String
    {
        var des = ""
        let paramEntitys = paramEntityList()
        paramEntitys.enumerated().forEach { (offset, entity) in
            des.append("\(entity.name): \(entity.name)")
            if offset != paramEntitys.count - 1{
                des.append(", ")
            }
        }
        return des
    }
    
    func requestPropertyListDes() -> String
    {
        var des = ""
        let paramEntitys = paramEntityList()
        paramEntitys.enumerated().forEach { (offset, entity) in
            des.append(propertyDes(entity))
            if offset != paramEntitys.count - 1{
                des.append("\n    ")
            }
        }
        return des
    }
    
    func assignPropertyListDes() -> String
    {
        var des = ""
        let paramEntitys = paramEntityList()
        paramEntitys.enumerated().forEach { (offset, entity) in
            des.append(assignPropertyOneDes(entity))
            if offset != paramEntitys.count - 1{
                des.append("\n        ")
            }
        }
        return des
    }
    
    func paramContentStringDes() -> String
    {
        var des = ""
        let paramEntitys = paramEntityList()
        paramEntitys.enumerated().forEach { (offset, entity) in
            des.append("\"\(entity.name)\": \(entity.name)")
            if offset != paramEntitys.count - 1{
                des.append(",\n            ")
            }
        }
        if des.isEmpty {
            des = ":"
        }
        return des
    }
    
    func typeDes(_ type: ParamType) -> String
    {
        switch type {
        case .intType:
            return "Int"
        case .stringType:
            return "String"
        case .dictionaryType:
            return "[String : Any]"
        case .arrayType:
            return "[Any]"
        }
    }
    
    func defaultValueDes(_ type: ParamType) -> String
    {
        switch type {
        case .intType:
            return "0"
        case .stringType:
            return "\u{0022}\u{0022}"
        case .dictionaryType:
            return "[:]"
        case .arrayType:
            return "[]"
        }
    }
    
    func propertyDes(_ entity: ParamEntity) -> String
    {
        let typeStr = typeDes(entity.type)
        let defaultDes = defaultValueDes(entity.type)
        return "var \(entity.name): \(typeStr) = \(defaultDes)"
    }
    
    func assignPropertyOneDes(_ entity: ParamEntity) -> String
    {
        return "self.\(entity.name) = \(entity.name)"
    }
}
