//
//  MessageManager.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

extension PonyChatUI {
    
    public class MessageManager {
        
        public weak var delegate: PonyChatUI.UserInterface.MainInteractor?
        
        public var items: [Entity.Message]? = nil
        
        public init() {
            let debug = Entity.TextMessage(mID: "abc", mDate: NSDate(), text: "🙅")
            var aSender = Entity.Message.Sender()
            aSender.isOwnSender = true
            aSender.senderAvatarURLString = "https://avatars1.githubusercontent.com/u/5013664?v=3&s=460"
            debug.messageSender = aSender
            
            items = [
                debug
            ]
        }
        
    }
    
}