//
//  FileService.swift
//  MogoAirport
//
//  Created by luhao on 06/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Foundation

enum FileError: Error
{
    case alreadyExist
}

struct FileService
{
    var entity: BuilderEntity
    var fileMgr = FileManager.default
    
    
    init(entity aEntity: BuilderEntity)
    {
        entity = aEntity
    }
    
    func makeWingDirectory() throws
    {
        try fileMgr.createDirectory(at: entity.wingFolder,
                                withIntermediateDirectories: true,
                                attributes: nil)
    }
    
    func write(content: String, toFile file: String) throws
    {
        let contentData = content.data(using: .utf8)
        if fileMgr.fileExists(atPath: file) {
            throw FileError.alreadyExist
        }
        
        do {
            try makeWingDirectory()
        } catch let error {
            print("\(error)")
        }
        
        fileMgr.createFile(atPath: file, contents: contentData, attributes: nil)
    }
    
    func creatWingFile(_ content: String) throws
    {
        try write(content: content, toFile: entity.wingFilePath)
    }
    
    func creatWingRequestFile(_ content: String) throws
    {
        try write(content: content, toFile: entity.wingRequestFilePath)
    }
    
    func creatMockPlistFile(_ content: String) throws
    {
        try write(content: content, toFile: entity.wingPlistFilePath)
    }
    
    func addPodSubspec(_ subpod: String) throws
    {
        let addData = subpod.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        let podspecPath = entity.projectLoc.appendingPathComponent("MGRenterApiWings.podspec")
        
        let writeHandle = try FileHandle(forWritingTo: podspecPath)
        
        var fileSize : UInt64 = 0
        
        do {
            let attr = try fileMgr.attributesOfItem(atPath: podspecPath.path)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            
        } catch {
            print("Error: \(error)")
        }
        
        writeHandle.seek(toFileOffset: fileSize-4)
        writeHandle.write(addData)
    }
}
