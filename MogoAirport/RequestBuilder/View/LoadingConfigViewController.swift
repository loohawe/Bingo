//
//  LoadingConfigViewController.swift
//  MogoAirport
//
//  Created by luhao on 20/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import SnapKit

class LoadingConfigViewController: NSViewController {

    @IBOutlet weak var chooseButton: NSButton!
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var selectorView: NSView!
    
    private var dataCenter: YamlDataService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.isHidden = true
        selectorView.isHidden = true
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let location = StoreService().ymlFilePath {
            loadYmlFile(location)
        }
    }
    
    @IBAction func chooseButtonAction(_ sender: NSButton) {
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.begin { [weak openPanel, weak self] (result) in
            guard let `openPanel` = openPanel, let `self` = self else { return }
            
            if result.rawValue == NSFileHandlingPanelOKButton {
                guard let location = openPanel.url else { return }
                
                self.loadYmlFile(location)
                StoreService().ymlFilePath = location
            }
        }
    }
    
    private func loadYmlFile(_ location: URL) {
        /// 判断文件是不是 Yaml 格式
        let file = try! BingoFileService(path: location)
        if !file.isFileType("yml") {
            AlertService.showAlert(inView: self.view, massage: "请选择 Bingo.yml 配置文件", okButtonTitle: "确定")
        } else {
            
            let yaml: YamlLoadedService
            do {
                try yaml = YamlLoadedService(file.readFile())
            } catch let error {
                print(error)
                AlertService.showAlert(inView: self.view, massage: "解析 yml 文件错误, 请选择合法的 yml 文件.", okButtonTitle: "确定")
                return
            }
            dataCenter = YamlDataService(yaml)
            
            guard let thisWindow = self.view.window else { fatalError() }
            var frame = thisWindow.frame
            frame.origin.y = frame.origin.y - (500.0 - frame.size.height)
            frame.size.height = 500.0
            self.view.window?.setFrame(frame, display: true)
            self.containerView.isHidden = false
            self.selectorView.isHidden = false
            
            self.chooseButton.title = "...\(String(location.absoluteString.suffix(26)))"
            
            openProjectSelector(dataCenter.projectNames)
        }
    }
    
    private func openProjectSelector(_ projList: [String]) {
        print(projList)
        
        let selectView: ListSelectedView = ListSelectedView.generateView()
        let selectViewModel = ListSelectedViewModel(name: "选择工程", options: projList)
        
        selectView.name = selectViewModel.name
        selectViewModel.options.bind(to: selectView.rx.options).disposed(by: rx.disposeBag)
        
        selectorView.addSubview(selectView)
        selectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

