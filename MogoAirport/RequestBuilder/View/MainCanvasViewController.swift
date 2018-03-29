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
    
    private var dataCenter: YamlDataService!
    /// 生成各种 UI 元素
    private var elementFactory: ElementFactoryViewModel!
    private var elementViews: [BGView] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Public method
extension MainCanvasViewController {
}

// MARK: - Private method
extension MainCanvasViewController {
    
    private func addSubviews() {
        elementViews.forEach { $0.removeFromSuperview() }
        
        elementViews = elementFactory.product(configers: dataCenter.uiConfiger)
        var originY: CGFloat = 0
        elementViews.forEach { (item) in
            
            let fitHeight = item.fittingSize.height
            
            scrollView.addSubview(item)
            item.snp.makeConstraints { (make) in
                make.topMargin.equalTo(originY)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(fitHeight)
            }
            originY += fitHeight
        }
    }
}
