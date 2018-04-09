//
//  XibLoadable.swift
//  MogoAirport
//
//  Created by luhao on 20/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import SnapKit

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

extension NSView {
    
    /// 给当前 view 添加一个 subview, 该 subview 从 xib 初始化而来
    /// 该 subview 讲撑满他的 super view
    ///
    /// - Parameter view: xib view 的类型
    /// - Returns: xib view 的实例
    public func addedSubviewForClass<T>(_ viewClass: T.Type) -> T where T: NSView, T: XibLoadable {
        let subView: T = viewClass.generateView()
        addSubview(subView)
        subView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return subView
    }
}
