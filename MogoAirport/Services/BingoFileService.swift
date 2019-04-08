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

extension String {
    
    /// 当路径中含有 .. 或 . 时, 计算出绝对路径地址
    ///
    /// - Parameter path: 当前的路径
    /// - Returns: 全路径
    public func absolutePath(withCurrentPath path: String) -> String {
        
        if !hasPrefix("./") && !hasPrefix("../") {
            return self
        }
        
        var hostComp = components(separatedBy: "/")
        var currentPathComp = path.components(separatedBy: "/")
        
        for i in 0..<hostComp.count {
            if hostComp[0] == "." {
                hostComp.remove(at: 0)
            } else if hostComp[0] == ".." {
                if !currentPathComp.isEmpty {
                    currentPathComp.remove(at: currentPathComp.count - 1)
                }
                hostComp.remove(at: 0)
            } else {
                break
            }
        }
        
        if currentPathComp.isEmpty {
            currentPathComp.append("")
        }
        currentPathComp.append(contentsOf: hostComp)
        
        return currentPathComp.joined(separator: "/")
    }
}
