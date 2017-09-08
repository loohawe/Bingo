//
//  FileRanderService.swift
//  MogoAirport
//
//  Created by luhao on 06/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Foundation
import Mustache

struct FileRenderService
{
    var entity: BuilderEntity
    
    init(entity aEntity: BuilderEntity)
    {
        entity = aEntity
    }
    
}

// MARK: Method Public

extension FileRenderService
{
    func rendWingFile() throws -> String
    {
        let wingFile = try render(template: const_file_wing, data: entity.buildRenderMapping())
        return wingFile
    }
    
    func rendWingRequestFile() throws -> String
    {
        let requestFile = try render(template: const_file_request, data: entity.buildRenderMapping())
        return requestFile
    }
    
    func rendMockPlistFile() throws -> String
    {
        let plist = try render(template: const_file_mockPlist, data: entity.buildRenderMapping())
        return plist
    }
    
    func rendSubpodFile() throws -> String
    {
        let subpod = try render(template: const_file_subpod, data: entity.buildRenderMapping())
        return subpod
    }
}

// MARK: Method Private
extension FileRenderService
{
    fileprivate func render(template: String, data: [String : Any]) throws -> String
    {
        let templ = try Template(named: template)
        
        templ.register(firstCharacterLowcase(), forKey: "firstLowCase")
        templ.register(StandardLibrary.each, forKey: "each")
        let rendering = try templ.render(data)
        return rendering
    }
    
    fileprivate func firstCharacterLowcase() -> FilterFunction
    {
        let filter = Mustache.Filter { (name: String?) -> String? in
            guard let str = name else {
                return nil
            }
            let toindex = str.index(str.startIndex, offsetBy: 1)
            let firstC = str.substring(to: toindex).lowercased()
            let otherC = str.substring(from: toindex)
            return "\(firstC)\(otherC)"
        }
        return filter
    }
}
