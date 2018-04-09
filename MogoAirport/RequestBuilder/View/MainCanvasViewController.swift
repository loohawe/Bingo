//
//  MainCanvasViewController.swift
//  MogoAirport
//
//  Created by luhao on 20/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import SnapKit

public class MainCanvasViewController: NSViewController {

    @IBOutlet private weak var scrollView: BGScrollView!
    
    private var elementFactory: ElementFactoryViewModel?
    /// 生成各种 UI 元素
    private var elementViews: [BGView] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidLayout() {
        super.viewDidLayout()
        
        updateScrollDocumentView()
    }
}

// MARK: - Public method
extension MainCanvasViewController {
    
    public func setElementFactory(_ eleFac: ElementFactoryViewModel) {
        elementFactory = eleFac
    }
    
    public func displayElement() {
        addSubviews()
    }
}

// MARK: - Private method
extension MainCanvasViewController {
    
    private func addSubviews() {
        guard let `elementFactory` = elementFactory else {
            return
        }
        elementViews.forEach { $0.removeFromSuperview() }
        
        elementViews = elementFactory.views
        var originY: CGFloat = 0
        elementViews.forEach { (item) in
            
            let fitHeight = item.fittingSize.height
            
            scrollView.contentView.addSubview(item)
            //print(originY)
            item.snp.makeConstraints { (make) in
                make.top.equalTo(originY)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(fitHeight)
            }
            originY += fitHeight
        }
        
        updateScrollDocumentView()
    }
    
    private func updateScrollDocumentView() {
        
        var originY: CGFloat = 0
        elementViews.forEach { (item) in
            originY += item.fittingSize.height
        }
        
        if let docView = scrollView.documentView {
            docView.frame =
                CGRect(x: 0,
                       y: 0,
                       width: scrollView.frame.width,
                       height: originY)
        }
        
    }
}
