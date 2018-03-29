//
//  BuilderContent.swift
//  MogoAirport
//
//  Created by luhao on 06/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Foundation
import RxSwift

let const_key_wingName = "wingName"
let const_key_requestPath = "requestPath"
let const_key_httpMethod = "httpMethod"
let const_key_wingParamsString = "wingParamsString"
let const_key_requestInitString = "requestInitString"
let const_key_requestPropertyList = "requestPropertyList"
let const_key_assignProperty = "assignProperty"
let const_key_paramsContentString = "paramsContentString"
let const_key_requestType = "requestType"
let const_key_responseFetcher = "responseFetcher"
let const_key_resultSuccessType = "resultSuccessType"

let const_file_wing = "wing"
let const_file_request = "request"
let const_file_mockPlist = "mockPlist"
let const_file_subpod = "subpod"

fileprivate let wingsGroupFolderName = "MGRenterApiWings"//"MGPartnerApiWings"

let const_fetcher_content = "contentFetcher"
let const_fetcher_message = "messageFetcher"
let const_fetcher_messageAndContent = "messageAndContentFercher"

enum HttpMethod
{
    case post
    case get
}

enum RequestType
{
    case fungi
    case mogo
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
    
    var requestType = RequestType.fungi
    var requestTypeDes: String {
        switch requestType {
        case .fungi:
            return "FungiRequest"
        case .mogo:
            return "MogoRequest"
        }
    }
    var responseFetcher = const_fetcher_content
    var resultSuccessTypeDes: String {
        switch responseFetcher {
        case const_fetcher_content:
            return "[String : Any]"
        case const_fetcher_message:
            return "String"
        case const_fetcher_messageAndContent:
            return "(String, [String : Any])"
        default:
            return "<#Unrecognize Type#>"
        }
    }
    
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
    
    var podspecFilePath: URL {
        return projectLoc.appendingPathComponent("\(wingsGroupFolderName).podspec")
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
        map[const_key_requestType] = requestTypeDes
        map[const_key_responseFetcher] = responseFetcher
        map[const_key_resultSuccessType] = resultSuccessTypeDes
        
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
