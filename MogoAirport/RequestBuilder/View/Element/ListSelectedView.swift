//
//  ListSelectedView.swift
//  MogoAirport
//
//  Created by luhao on 26/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

public class ListSelectedView: BGView, XibLoadable {
    
    public var name: String = "" {
        didSet {
            nameLabel.stringValue = name
        }
    }
    public var selectIndex: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    private var options: [String] = []

    @IBOutlet internal weak var nameLabel: NSTextField!
    @IBOutlet private weak var optionsButton: NSPopUpButton!
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override public var fittingSize: NSSize {
        let size = super.fittingSize
        return NSSize(width: size.width, height: 30.0)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        optionsButton.target = self
        optionsButton.action = #selector(selectOption)
        nameLabel.stringValue = name
    }
    
    @objc func selectOption() {
        if let secTitle = optionsButton.titleOfSelectedItem,
            let index = options.index(of: secTitle) {
            selectIndex.onNext(index)
        }
    }
}

extension ListSelectedView: ElementViewProtocol {
    
    var value: Any? {
        return optionsButton.titleOfSelectedItem
    }
    
    func emptyValue() {
        selectIndex.onNext(0)
        optionsButton.setTitle(options.first ?? "")
    }
}

// MARK: - Public method
extension ListSelectedView {
    
    public func setupOptions(_ ops: [String]) {
        options = ops
        
        optionsButton.removeAllItems()
        optionsButton.addItems(withTitles: ops)
    }
    
}

extension Reactive where Base == ListSelectedView {
    
    public var options: Binder<[String]> {
        return Binder(base, binding: { (base, ops) in
            base.setupOptions(ops)
        })
    }
}
