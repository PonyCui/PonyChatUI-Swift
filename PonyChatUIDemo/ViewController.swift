//
//  ViewController.swift
//  PonyChatUIDemo
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import UIKit
import PonyChatUI

class ViewController: UIViewController, PonyChatUIDelegate, UITextFieldDelegate {
    
    var preloaded = false

    let messageManager = DemoMessageManager()
    
    var chatViewController: PonyChatUI.UserInterface.MainViewController?
    var chatView: UIView?
    
    let toolViewController = UIStoryboard(name: "Main",
        bundle: nil).instantiateViewControllerWithIdentifier("ToolViewController")
    
    func configureMenu() {
        let deleteItem = PonyChatUI.UserInterface.LongPressEntity(title: "删除") { (message, chatViewController) -> Void in
            if let messageManager = chatViewController?.eventHandler.interactor.manager {
                messageManager.deleteItem(message)
            }
        }
        PonyChatUI.UserInterface.Configure.sharedConfigure.longPressItems = [
            deleteItem
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenu()
        if preloaded {
            if let chatViewController = chatViewController, let chatView = chatView {
                chatViewController.footerViewHeight = 44
                chatViewController.coreDelegate = self
                chatViewController.removeFromParentViewController()
                chatView.removeFromSuperview()
                addChildViewController(chatViewController)
                view.addSubview(chatView)
            }
        }
        else {
            loadHistory()
            toolViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
            let chatMain = PonyChatUICore.sharedCore.wireframe.main(messageManager,
                messagingConfigure: nil,
                footerView: toolViewController.view)
            chatMain.0.footerViewHeight = 44
            chatMain.0.coreDelegate = self
            chatViewController = chatMain.0
            chatView = chatMain.1
            addChildViewController(chatMain.0)
            view.addSubview(chatMain.1)
        }
        if let textField = toolViewController.view.viewWithTag(1000) as? UITextField {
            textField.delegate = self
        }
    }
    
    func loadHistory() {
        var items: [PonyChatUI.Entity.Message] = []
        
        let systemMessage = PonyChatUI.Entity.SystemMessage(mID: "system", mDate: NSDate(), text: "[播放] 这是一条系统消息 [垃圾]")
        items.append(systemMessage)
        
        func m_0() -> () {
            for i in 0...50 {
                let random = Double(arc4random() % 200)
                let mDate = NSDate(timeIntervalSinceNow: -86400 * 5 + 200 * Double(i) + random)
                var aSender = PonyChatUI.Entity.Message.Sender()
                aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
                aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
                aSender.senderNickname = "Pony"
                let message = PonyChatUI.Entity.TextMessage(mID: "text\(i)", mDate: mDate, text: "\(mDate.description)")
                message.messageSender = aSender
                items.append(message)
            }
        }
        
        func m_1() -> () {
            let mDate = NSDate(timeIntervalSinceNow: -86400 * 3 + 200)
            let imageMessage = PonyChatUI.Entity.ImageMessage(mID: "image", mDate: mDate, imageURLString: "http://ww1.sinaimg.cn/large/c631b412jw1exizdhe4q2j21kw11x7fm.jpg", thumbURLString: "http://ww1.sinaimg.cn/bmiddle/c631b412jw1exizdhe4q2j21kw11x7fm.jpg", imageSize: CGSize(width: 2048, height: 1365))
            var aSender = PonyChatUI.Entity.Message.Sender()
            aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
            aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
            aSender.senderNickname = "Pony"
            imageMessage.messageSender = aSender
            items.append(imageMessage)
        }
        
        func m_2() -> () {
            let mDate = NSDate(timeIntervalSinceNow: -86400 * 2 + 200)
            let imageMessage = PonyChatUI.Entity.ImageMessage(mID: "gifimage", mDate: mDate, imageURLString: "http://pics.sc.chinaz.com/Files/pic/faces/2425/26.gif", thumbURLString: "http://pics.sc.chinaz.com/Files/pic/faces/2425/26.gif", imageSize: CGSize(width: 75, height: 75))
            var aSender = PonyChatUI.Entity.Message.Sender()
            aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
            aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
            aSender.senderNickname = "Pony"
            imageMessage.messageSender = aSender
            items.append(imageMessage)
        }
        
        func m_3() -> () {
            for i in 0...50 {
                let random = Double(arc4random() % 200)
                let mDate = NSDate(timeIntervalSinceNow: -86400 * 4 + 200 * Double(i) + random)
                var aSender = PonyChatUI.Entity.Message.Sender()
                aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
                aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
                aSender.senderNickname = "Pony"
                let message = PonyChatUI.Entity.VoiceMessage(mID: "voice\(i)", mDate: mDate, voiceURLString: "xxxxx", voiceDuration: Double(arc4random() % 100))
                if i > 40 {
                    message.voicePlayed = false
                }
                message.messageSender = aSender
                items.append(message)
            }
        }
        
        m_0()
        m_3()
        m_1()
        m_2()
        
        messageManager.insertItems(items)
    }
    
    func mockMessage() {
        var aSender = PonyChatUI.Entity.Message.Sender()
        aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
        aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
        aSender.senderNickname = "Pony"
        let message = PonyChatUI.Entity.TextMessage(mID: "mock\(NSDate().description)", mDate: NSDate(), text: NSDate().description)
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
            nextViewController.toolViewController.view.frame = CGRect(
                x: 0,
                y: 0,
                width: self.view.bounds.width,
                height: 44)
            PonyChatUICore.sharedCore.wireframe.preload(nextViewController.messageManager, messagingConfigure: nil, footerView: nextViewController.toolViewController.view, size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 64.0), completion: { (mainViewController, mainView) -> Void in
                nextViewController.chatViewController = mainViewController
                nextViewController.chatView = mainView
                self.navigationController?.pushViewController(nextViewController, animated: true)
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            let textMessage = PonyChatUI.Entity.TextMessage(mID: "Send.\(NSDate().description)", mDate: NSDate(), text: text)
            var aSender = PonyChatUI.Entity.Message.Sender()
            aSender.isOwnSender = true
            aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
            aSender.senderNickname = "Pony"
            textMessage.messageSender = aSender
            messageManager.appendItem(textMessage)
        }
        textField.text = nil
        return true
    }
    
    func chatUIRequestOpenURL(URL: NSURL) {
        UIApplication.sharedApplication().openURL(URL)
    }
    
    func chatUIRequestOpenLargeImage(messageItem: PonyChatUI.Entity.ImageMessage, originRect: CGRect) {
        print(messageItem)
        print(originRect)
    }
    
    var nowPlayingItem: PonyChatUI.Entity.VoiceMessage?
    var nowPaused = true
    func chatUIRequestPlayVoiceMessages(messageItems: [PonyChatUI.Entity.VoiceMessage]) {
        nowPaused = false
        var i: UInt64 = 0
        for item in messageItems {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * i * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
                if self.nowPaused {
                    return
                }
                self.nowPlayingItem = item
                item.voicePlaying = true
                item.voicePlayed = true
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * i + 3 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
                    item.voicePlaying = false
                }
            }
            i++
        }
    }
    
    func chatUIRequestPauseVoicePlaying(messageItem: PonyChatUI.Entity.VoiceMessage) {
        nowPaused = true
        if let nowPlayingItem = nowPlayingItem {
            nowPlayingItem.voicePlaying = false
        }
        messageItem.voicePlaying = false
    }
    
    func chatUIRequestOpenUserPage(user: PonyChatUI.Entity.Message.Sender) {
        print(user)
    }
    
    func chatUIRequestResendMessage(messageItem: PonyChatUI.Entity.Message) {
        print(messageItem)
    }

}

class DemoMessageManager: PonyChatUI.MessageManager {
    
    override init() {
        super.init()
        canFetchPreviousItems = true
    }
    
    var iii: Double = 10
    override func beginFetchPreviousItems() {
        if isFetchingPreviousItems {
            return
        }
        super.beginFetchPreviousItems()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            var items: [PonyChatUI.Entity.Message] = []
            for i in 0...50 {
                let random = Double(arc4random() % 200)
                let mDate = NSDate(timeIntervalSinceNow: -86400 * self.iii + 200 * Double(i) + random)
                var aSender = PonyChatUI.Entity.Message.Sender()
                aSender.isOwnSender = arc4random() % 2 == 0 ? true : false
                aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
                aSender.senderNickname = "Pony"
                let message = PonyChatUI.Entity.TextMessage(mID: "text\(arc4random())", mDate: mDate, text: "\(mDate.description)")
                message.messageSender = aSender
                items.append(message)
            }
            self.insertItems(items)
            self.endFetchPreviousItems()
            self.iii++
        }
    }
}

