//
//  XibLoadable.swift
//  MogoAirport
//
//  Created by luhao on 20/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa

public protocol XibLoadable: NSObjectProtocol {
    
    /// 从 Xib 初始化一个 NSView 出来
    ///
    /// - Returns:
    static func generateView<T>() -> T
    static func setup(_ view: Self)
}

extension XibLoadable {
    
    public static func generateView<T>() -> T {
        var array: NSArray? = []
        if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "\(self)"), owner: self, topLevelObjects: &array) {
            var someView: Self?
            if let `array` = array {
                array.forEach({ (item) in
                    if let desView = item as? Self {
                        someView = desView
                    }
                })
            }
            if let resultView = someView {
                setup(resultView)
                if let viewInstance = resultView as? T {
                    return viewInstance
                } else {
                    fatalError("Xib 中没有找到 NSView 类")
                }
            } else {
                fatalError("Can not find NSView from xib")
            }
        } else {
            fatalError("Load From xib failure!")
        }
    }
    
    public static func setup(_ view: Self) {
        
    }
}
