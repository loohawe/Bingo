//
//  BuilderContent.swift
//  MogoAirport
//
//  Created by luhao on 06/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Foundation
import RxSwift

fileprivate let wingsGroupFolderName = "MGRenterApiWings"

let const_key_wingName = "wingName"
let const_key_requestPath = "requestPath"
let const_key_httpMethod = "httpMethod"
let const_key_wingParamsString = "wingParamsString"
let const_key_requestInitString = "requestInitString"
let const_key_requestPropertyList = "requestPropertyList"
let const_key_assignProperty = "assignProperty"
let const_key_paramsContentString = "paramsContentString"

let const_file_wing = "wing"
let const_file_request = "request"
let const_file_mockPlist = "mockPlist"
let const_file_subpod = "subpod"

enum HttpMethod {
    case post
    case get
}

class BuilderEntity
{
    init(projectLocation: URL)
    {
        projectLoc = projectLocation
    }
    
    var projectLoc: URL {
        didSet {
            locSubject.onNext(projectLoc)
        }
    }
    var hatName = ""
    var method = HttpMethod.post
    var path = ""
    var wingParamsString: String = ""
    var requestInitString: String = ""
    var requestPropertyDes: String = ""
    var assignProperty: String = ""
    var paramsContentString: String = ":"
    
    var locSubject = PublishSubject<URL>()
    
    var wingsGroupFolder: URL {
        return projectLoc.appendingPathComponent(wingsGroupFolderName)
    }
    
    var wingName: String {
        return "MGR\(hatName)"
    }
    
    var wingRequestName: String {
        return "\(hatName)Request"
    }
    
    var wingPlistName: String {
        return "\(hatName)"
    }
    
    var wingFolder: URL {
        return wingsGroupFolder.appendingPathComponent(wingName)
    }
    
    var wingFilePath: String {
        return wingFolder.appendingPathComponent(wingName).appendingPathExtension("swift").path
    }
    
    var wingRequestFilePath: String {
        return wingFolder.appendingPathComponent(wingRequestName).appendingPathExtension("swift").path
    }
    
    var wingPlistFilePath: String {
        return wingFolder.appendingPathComponent(wingPlistName).appendingPathExtension("plist").path
    }
    
    func buildRenderMapping() -> [String : Any]
    {
        var map: [String : Any] = [
            const_key_wingName: hatName,
            const_key_requestPath: path,
            const_key_httpMethod: methodString()
        ]
        
        if !wingParamsString.isEmpty {
            map[const_key_wingParamsString] = wingParamsString
        }
        
        if !requestPropertyDes.isEmpty {
            map[const_key_requestPropertyList] = requestPropertyDes
        }
        
        if !assignProperty.isEmpty {
            map[const_key_assignProperty] = assignProperty
        }
        
        map[const_key_requestInitString] = requestInitString
        map[const_key_paramsContentString] = paramsContentString
        
        return map
    }
}

extension BuilderEntity
{
    fileprivate func methodString() -> String
    {
        var methodDes = ".post"
        switch method {
        case .post:
            methodDes = ".post"
        case .get:
            methodDes = ".get"
        }
        return methodDes
    }
}
