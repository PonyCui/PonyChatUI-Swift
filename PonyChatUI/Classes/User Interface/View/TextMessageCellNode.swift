//
//  TextMessageCellNode.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

class TextMessageCellNode: PonyChatUI.UserInterface.MessageCellNode {
    
    var typedMessageItem: PonyChatUI.Entity.TextMessage? {
        if let messageItem = messageItem as? PonyChatUI.Entity.TextMessage {
            return messageItem
        }
        else {
            return nil
        }
    }
    
}