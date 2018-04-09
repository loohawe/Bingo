//
//  FilesManager.swift
//  MogoAirport
//
//  Created by luhao on 20/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import PathKit

class BingoFileService {
    
    let path: URL
    let pathObject: Path
    let isDirectory: Bool
    let fileManager: FileManager = FileManager.default
    
    init(path aPath: URL) throws {
        path = aPath
        pathObject = Path.init(aPath.path)
        let attr = try fileManager.attributesOfItem(atPath: aPath.path)
        if let fileType = attr[FileAttributeKey.type] as? FileAttributeType {
            isDirectory = fileType == FileAttributeType.typeDirectory
        } else {
            fatalError("没有找到文件的 Type 信息")
        }
        print(attr)
    }
    
    func isFileType(_ ext: String) -> Bool {
        return path.pathExtension == ext
    }
    
    func readFile() -> String {
        if isDirectory {
            fatalError("读取内容时, 目标文件不能为文件夹")
        }
        var result: String = ""
        do {
            try result = pathObject.read()
        } catch let error {
            print(error)
            fatalError("读取文件出错: \(error)")
        }
        //print("\(result)")
        return result
    }
    
}
