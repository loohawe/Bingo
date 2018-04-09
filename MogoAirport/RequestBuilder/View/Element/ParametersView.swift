//
//  ParametersView.swift
//  MogoAirport
//
//  Created by luhao on 06/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

public class ParametersView: BGView, XibLoadable {

    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var scrollView: BGScrollView!
    @IBOutlet weak var clearButton: NSButton!
    
    fileprivate var paramViews = [ParamView]() {
        didSet {
            updateClearParamButtonStatus()
        }
    }
    private let rowHeight: CGFloat = 36.0
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override public var fittingSize: NSSize {
        let size = super.fittingSize
        return NSSize(width: size.width, height: 199.0)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        updateClearParamButtonStatus()
    }
    
    override public func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        layoutParameterView()
    }
    
    @IBAction public func clearParametersAction(_ sender: NSButton) {
        clearParameters()
    }
    
    @IBAction public func addParametersAction(_ sender: NSButton) {
        let paramV: ParamView = ParamView.generateView()
        paramV.closeSubject.subscribe {
            [weak self, weak paramV](_) in
            
            guard let `self` = self else {return}
            guard let `paramV` = paramV else {return}
            
            if let index = self.paramViews.index(of: paramV) {
                paramV.removeFromSuperview()
                self.paramViews.remove(at: index)
                self.layoutParameterView(fromIndex: index)
                self.updateScrollContentView()
            }
            }.disposed(by: paramV.rxDisposeBag)
        addParameter(view: paramV)
    }
}

// MARK: - Private method
extension ParametersView {
    
    private func updateClearParamButtonStatus() {
        clearButton.isHidden = paramViews.isEmpty
    }
    
    private func addParameter(view: ParamView) {
        scrollView.contentView.addSubview(view)
        paramViews.insert(view, at: 0)
        layoutParameterView()
        updateScrollContentView()
    }
    
    private func layoutParameterView(fromIndex index: Int = 0) {
        guard index < paramViews.count else { return }
        paramViews.enumerated().forEach { (item) in
            if item.offset < index {
                return
            }
            
            item.element.frame = NSRect(x: 0,
                                        y: CGFloat(item.offset) * rowHeight,
                                        width: scrollView.frame.width,
                                        height: rowHeight)
        }
    }
    
    private func updateScrollContentView() {
        /// 设置 ScrollView 的 contentView
        if let docView = scrollView.documentView {
            docView.frame = CGRect(x: Double(docView.frame.origin.x),
                                   y: Double(docView.frame.origin.y),
                                   width: Double(scrollView.frame.width),
                                   height: Double(rowHeight * CGFloat(paramViews.count)))
        }
    }
    
    private func clearParameters() {
        paramViews.forEach { $0.removeFromSuperview() }
        paramViews.removeAll()
    }
}

extension ParametersView: ElementViewProtocol {
    
    var value: Any? {
        return paramViews
            .map { $0.paramEntity }
            .map {
                ($0.name, $0.type.rawValue)
        }
    }
    
    func emptyValue() {
        clearParameters()
    }
}
