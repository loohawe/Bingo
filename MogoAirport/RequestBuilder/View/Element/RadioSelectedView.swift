//
//  RadioSelectedView.swift
//  MogoAirport
//
//  Created by luhao on 05/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

public final class RadioSelectedView: BGView, XibLoadable {
    
    public var selectItem: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    @IBOutlet weak var nameLabel: NSTextField!
    private var _items: [String] = []
    private var _itemsButtons: [NSButton] = []
    
    private let btnH: CGFloat = 18.0
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override public var fittingSize: NSSize {
        let size = super.fittingSize
        return NSSize(width: size.width, height: CGFloat(39.0 + (btnH * ceil(CGFloat(_items.count) / 2.0))))
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        layoutItems(thisWidth: oldSize.width, thisHeight: oldSize.height)
    }
}

extension RadioSelectedView {
    
    public func setItems(_ list: [String]) {
        _items = list
        _itemsButtons.forEach { $0.removeFromSuperview() }
        _itemsButtons = _items.map(generateButton)
        
        needsLayout = true
    }
}

extension RadioSelectedView {
    
    @objc private func radioButtonAction(_ sender: NSButton) {
        _itemsButtons.forEach { (oneButton) in
            oneButton.state = oneButton.title == sender.title ? NSControl.StateValue.on : NSControl.StateValue.off
        }
        selectItem.onNext(sender.title)
    }
    
    private func generateButton(title: String) -> NSButton {
        let btn = NSButton(radioButtonWithTitle: title, target: self, action: #selector(radioButtonAction(_:)))
        return btn
    }
    
    private func layoutItems(thisWidth: CGFloat, thisHeight: CGFloat) {
        
        var row: CGFloat = 0
        var col: CGFloat = 0
        let originX: CGFloat = 136.0
        let originY: CGFloat = 20.0
        let spacing: CGFloat = 8.0
        let btnW: CGFloat = (thisWidth - originX - 3 * spacing) / 2
        _itemsButtons.forEach { (oneBtn) in
            let btnFrame = NSRect(x: originX + col * (btnW + spacing),
                                  y: originY + row * (btnH + spacing),
                                  width: btnW,
                                  height: btnH)
            oneBtn.frame = btnFrame
            addSubview(oneBtn)
            
            col += 1
            if col > 1 {
                row += 1
                col = 0
            }
        }
    }
}

extension RadioSelectedView: ElementViewProtocol {
    
    var value: Any? {
        return try? selectItem.value()
    }
    
    func emptyValue() {
        _itemsButtons.forEach { (oneButton) in
            oneButton.state = NSControl.StateValue.off
        }
    }
}

extension Reactive where Base == RadioSelectedView {
    
    var items: Binder<[String]> {
        return Binder(base, binding: { (base, value) in
            base.setItems(value)
        })
    }
}
