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
    
    var preloaded = false

    let messageManager = PonyChatUI.MessageManager()
    
    var chatViewController: PonyChatUI.UserInterface.MainViewController?
    var chatView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if preloaded {
            
        }
        else {
            loadHistory()
            let chatMain = PonyChatUICore.sharedCore.wireframe.main(messageManager)
            chatViewController = chatMain.0
            chatView = chatMain.1
            addChildViewController(chatMain.0)
            view.addSubview(chatMain.1)
        }
//        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "debug", userInfo: nil, repeats: true)
    }
    
    func loadHistory() {
        var items: [PonyChatUI.Entity.Message] = []
        for _ in 0...100 {
            var aSender = PonyChatUI.Entity.Message.Sender()
            aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
            aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
            let message = PonyChatUI.Entity.TextMessage(mID: "test", mDate: NSDate(), text: NSDate().description)
            message.messageSender = aSender
            items.append(message)
        }
        messageManager.insertItems(items)
    }
    
    func debug() {
        var aSender = PonyChatUI.Entity.Message.Sender()
        aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
        aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
        let message = PonyChatUI.Entity.TextMessage(mID: "test", mDate: NSDate(), text: NSDate().description)
        message.messageSender = aSender
        messageManager.appendItem(message)
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
    
    @IBAction func handleNextTapped(sender: AnyObject) {
        if let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as? ViewController {
            nextViewController.preloaded = true
            nextViewController.loadHistory()
            PonyChatUICore.sharedCore.wireframe.preload(nextViewController.messageManager, size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 64.0), completion: { (mainViewController, mainView) -> Void in
                nextViewController.chatViewController = mainViewController
                nextViewController.chatView = mainView
                mainViewController.removeFromParentViewController()
                mainView.removeFromSuperview()
                nextViewController.addChildViewController(mainViewController)
                nextViewController.view.addSubview(mainView)
                self.navigationController?.pushViewController(nextViewController, animated: true)
            })
        }
    }
    

}

