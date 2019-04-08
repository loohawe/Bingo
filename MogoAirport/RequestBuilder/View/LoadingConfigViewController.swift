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
import Stencil
import PathKit

class LoadingConfigViewController: NSViewController {
    

    /// UI
    @IBOutlet weak var chooseButton: NSButton!
    @IBOutlet weak var configerContainerView: NSView! /// 
    @IBOutlet weak var projectContainerView: NSView! /// 选择工程 view 的 container
    
    @IBOutlet weak var outputContainerView: BGView! /// 输出的 container
    private var outputView: OutputView!
    
    @IBOutlet weak var rightPannelWidth: NSLayoutConstraint! /// 右边面板宽度
    @IBOutlet weak var bottomPannelWidth: NSLayoutConstraint! /// 底部面板宽度
    
    @IBOutlet weak var bingoAction: NSLayoutConstraint!
    
    
    
    /// Data
    private var dataCenter: YamlDataService!
    private lazy var elementFactory: ElementFactoryViewModel = {
        let eleVM = ElementFactoryViewModel()
        eleVM.setDataCenter(dataCenter)
        return eleVM
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configerContainerView.isHidden = true
        projectContainerView.isHidden = true
        
        addOutputView()
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
            
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                guard let location = openPanel.url else { return }
                
                self.loadYmlFile(location)
                StoreService().ymlFilePath = location
            }
        }
    }
    

    @IBAction func bingoAction(_ sender: NSButton) {
        let kv = elementFactory.keyValue
        print(kv)
        
        /// 存结果时要取的文件名
        let environment = Environment()
        let fileName = dataCenter.template
            .map { (item) -> String in
                if let render = try? environment.renderTemplate(string: item, context: kv) {
                    if let url = URL(string: render) {
                        return url.lastPathComponent
                    }
                    return render
                }
                return ""
            }
        
        /// 原始的文件名
        let originFileName = dataCenter
        
        let originFiles = dataCenter.template.map { (item) -> Path in
            let path = item.absolutePath(withCurrentPath: StoreService().ymlFilePath!.path)
            let pathPart = path.components(separatedBy: "/")
            pathPart.dropLast()
            let folderPath = pathPart.joined(separator: "/")
            return Path.init(folderPath)
        }
        
        let fsLoader = FileSystemLoader(paths: originFiles)
        let env = Environment(loader: fsLoader)
        fileName.forEach { (itemFile) in
            let result = try? env.renderTemplate(name: itemFile, context: kv) ?? ""
            print(result)
        }
    }
    
    @IBAction func resetAction(_ sender: NSButton) {
        elementFactory.resetViews()
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
            
            /**
            guard let thisWindow = self.view.window else { fatalError() }
            var frame = thisWindow.frame
            frame.origin.y = frame.origin.y - (600.0 - frame.size.height)
            frame.size.height = 600.0
            self.view.window?.setFrame(frame, display: true)**/
            
            self.configerContainerView.isHidden = false
            self.projectContainerView.isHidden = false
            
            self.chooseButton.title = "...\(String(location.absoluteString.suffix(26)))"
            
            openProjectSelector(dataCenter.projectNames)
        }
    }
    
    private func openProjectSelector(_ projList: [String]) {
        //print(projList)
        
        let selectView: ListSelectedView = projectContainerView.addedSubviewForClass(ListSelectedView.self)
        let selectProjConfiger = UIConfigerItem(.List, key: "", candidate: projList, name: "选择工程")
        let selectViewModel = ListSelectedViewModel(selectProjConfiger)
        
        selectView.name = selectViewModel.name
        selectViewModel.options.bind(to: selectView.rx.options).disposed(by: rxDisposeBag)
        
        selectView.selectIndex
            //.debug()
            .subscribe(onNext: dataCenter.selectProject)
            .disposed(by: rxDisposeBag)
        
        selectView.selectIndex
            .subscribe(onNext: { [weak self] (_) in
                
                guard let `self` = self else { return }
                self.elementFactory.updateElement()
                self.findMainCanvasViewController()?.setElementFactory(self.elementFactory)
                self.findMainCanvasViewController()?.displayElement()
            })
            .disposed(by: rxDisposeBag)
    }
    
    private func findMainCanvasViewController() -> MainCanvasViewController? {
        var mainCanvas: MainCanvasViewController?
        childViewControllers.forEach { (item) in
            if let mainVC = item as? MainCanvasViewController {
                mainCanvas = mainVC
            }
        }
        return mainCanvas
    }
}

extension LoadingConfigViewController {
    
    private func addOutputView() {
        outputView = outputContainerView.addedSubviewForClass(OutputView.self)
        
        /**
        DispatchQueue.global().async {
            for _ in 0...1000 {
                sleep(1)
                DispatchQueue.main.async {
                    let randomInt: UInt32 = arc4random()
                    if randomInt % 2 == 0 {
                        self.outputView.startLoading()
                    } else {
                        self.outputView.endLoading()
                    }
                    self.outputView.output("--\(randomInt)--")
                }
            }
        }**/
    }
}

