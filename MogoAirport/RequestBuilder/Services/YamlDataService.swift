//
//  YamlDataService.swift
//  MogoAirport
//
//  Created by luhao on 22/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import Yaml

public enum ProjectKey: String {
    case Project
    case Template
    case Output
    case UI
}

public enum UIKey: String {
    case UIType = "Type"
    case Key
    case Value
    case Candidate
    case Name
}

public enum UIType: String {
    case SelectFile
    case Input
    case Radio
    case List
    case Param
}

public class UIConfigerItem {
    public var type: UIType
    public var key: String
    public var value: Any?
    public var candidate: [String]
    public var name: String
    
    public init(_ type: UIType, key: String, candidate: [String], name: String) {
        self.type = type
        self.key = key
        self.candidate = candidate
        self.name = name
    }
    
    public init(_ yaml: Yaml) {
        guard let yamlUIDic = yaml.dictionary else {
            fatalError("配置文件 UI 段错误")
        }
        
        guard let typeStr = yamlUIDic[Yaml(stringLiteral: UIKey.UIType.rawValue)]?.string,
            let uitype = UIType(rawValue: typeStr) else {
                fatalError("配置文件的 UI 段, 必须包含 type 信息")
        }
        type = uitype
        
        guard let keyStr = yamlUIDic[Yaml(stringLiteral: UIKey.Key.rawValue)]?.string else {
            fatalError("配置文件的 UI 段, 必须包含 key 信息")
        }
        key = keyStr
        
        if let yamlList = yamlUIDic[Yaml(stringLiteral: UIKey.Candidate.rawValue)]?.array {
            candidate = yamlList.map { $0.string ?? "" }
        } else {
            candidate = []
        }
        
        guard let nameStr = yamlUIDic[Yaml(stringLiteral: UIKey.Name.rawValue)]?.string else {
            fatalError("配置文件的 UI 段, 必须包含 name 信息")
        }
        name = nameStr
    }
}

public class YamlDataService {
    
    let loaded: YamlLoadedService
    var projectIndex: Int?
    
    lazy var projectNames: [String] = {
        guard let projList = loaded.yamlValue.array else {
            fatalError("配置文件格式出错")
        }
        return projList.map{ (yml) -> String in
            guard let ymlDic = yml.dictionary else { return "" }
            return ymlDic[Yaml.init(stringLiteral: ProjectKey.Project.rawValue)]?.string ?? ""
        }
    }()
    
    var template: [String] {
        guard let `projectIndex` = projectIndex else {
            fatalError("获取数据前请先调用 selectProject(_:) 方法指定第几个工程")
        }
        return getTemplate(at: projectIndex)
    }
    
    var output: String {
        guard let `projectIndex` = projectIndex else {
            fatalError("获取数据前请先调用 selectProject(_:) 方法指定第几个工程")
        }
        return getOutput(at: projectIndex)
    }
    
    var uiConfiger: [UIConfigerItem] {
        guard let `projectIndex` = projectIndex else {
            fatalError("获取数据前请先调用 selectProject(_:) 方法指定第几个工程")
        }
        return getUIConfigers(at: projectIndex)
    }
    
    init(_ yamlLoaded: YamlLoadedService) {
        loaded = yamlLoaded
    }
    
    public func selectProject(_ index: Int) {
        projectIndex = index
        //print("###\(index)")
    }
    
    /// 获取配置文件中的模板文件路径
    ///
    /// - Parameter index: 第几个工程
    /// - Returns:
    private func getTemplate(at index: Int) -> [String] {
        guard index < projectNames.count else { fatalError("获取配置文件信息越界") }
        guard let ymlProjDic = loaded.yamlValue.array?[index].dictionary else { return [] }
        guard let ymlTemList = ymlProjDic[Yaml(stringLiteral: ProjectKey.Template.rawValue)]?.array else { return [] }
        return ymlTemList.map { $0.string ?? "" }
    }
    
    /// 获取配置文件中输出文件路径
    ///
    /// - Parameter index: 第几个工程
    /// - Returns:
    private func getOutput(at index: Int) -> String {
        guard index < projectNames.count else { fatalError("获取配置文件信息越界") }
        guard let ymlProjDic = loaded.yamlValue.array?[index].dictionary else { return "" }
        return ymlProjDic[Yaml(stringLiteral: ProjectKey.Output.rawValue)]?.string ?? ""
    }
    
    /// 获取配置文件中工程对应 UI 的布局信息
    ///
    /// - Parameter index: 第几个工程
    /// - Returns:
    private func  getUIConfigers(at index: Int) -> [UIConfigerItem] {
        guard index < projectNames.count else { fatalError("获取配置文件信息越界") }
        guard let ymlProjDic = loaded.yamlValue.array?[index].dictionary else { return [] }
        guard let ymlUIDicList = ymlProjDic[Yaml(stringLiteral: ProjectKey.UI.rawValue)]?.array else {
                fatalError("获取配置 UI 段出错")
        }
        return ymlUIDicList.map { UIConfigerItem($0) }
    }
}
