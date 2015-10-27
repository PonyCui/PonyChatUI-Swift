//
//  ViewController.swift
//  PonyChatUIDemo
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import UIKit
import PonyChatUI

class ViewController: UIViewController {

    var chatViewController: PonyChatUI.UserInterface.MainViewController?
    var chatView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageManager = PonyChatUI.MessageManager()
        let chatMain = PonyChatUICore.sharedCore.wireframe.main(messageManager)
        chatViewController = chatMain.0
        chatView = chatMain.1
        addChildViewController(chatMain.0)
        view.addSubview(chatMain.1)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let chatView = chatView {
            chatView.frame = view.bounds
        }
    }

}

