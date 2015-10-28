//
//  TextMessageCellNode.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation
import AsyncDisplayKit

extension PonyChatUI.UserInterface {
    
    class TextMessageCellNode: PonyChatUI.UserInterface.MessageCellNode {
        
        let textNode = ASTextNode()
        let backgroundNode = ASImageNode()
        
        var typedMessageItem: PonyChatUI.Entity.TextMessage? {
            if let messageItem = messageItem as? PonyChatUI.Entity.TextMessage {
                return messageItem
            }
            else {
                return nil
            }
        }
        
        override func configureNodes() {
            super.configureNodes()
            contentNode.addSubnode(backgroundNode)
            contentNode.addSubnode(textNode)
        }
        
        override func configureDatas() {
            super.configureDatas()
            configureTextNode()
        }
        
        func configureTextNode() {
            if let item = typedMessageItem {
                let attributedString = NSAttributedString(string: item.text,
                    attributes: messagingConfigure.textStyle)
                textNode.attributedString = attributedString
            }
        }
        
        override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
            let superSize = super.calculateSizeThatFits(constrainedSize)
            let textBoxWidth = constrainedSize.width - messagingConfigure.avatarSize.width - messagingConfigure.avatarEdge.left - messagingConfigure.avatarEdge.right - messagingConfigure.textEdge.left - messagingConfigure.textEdge.right - 60.0
            let textSize = self.textNode.measure(CGSize(width: textBoxWidth, height: constrainedSize.height))
            let requiredHeight = max(superSize.height, nicknameHeight + textSize.height + messagingConfigure.textEdge.top + messagingConfigure.textEdge.bottom)
            contentNode.frame = CGRectMake(0, 0, constrainedSize.width, requiredHeight + messagingConfigure.cellGaps)
            return CGSize(width: constrainedSize.width, height: requiredHeight + messagingConfigure.cellGaps)
        }
        
        override func layout() {
            super.layout()
            if let sender = messageItem.messageSender {
                var textRect = CGRect()
                textRect.size = self.textNode.calculatedSize
                if sender.isOwnSender {
                    textRect.origin = CGPoint(x: avatarNode.frame.origin.x - messagingConfigure.avatarEdge.left - textRect.size.width - messagingConfigure.textEdge.right, y: messagingConfigure.textEdge.top + nicknameNode.frame.size.height + 3.0)
                }
                else {
                    textRect.origin = CGPoint(x: avatarNode.frame.origin.x + avatarNode.frame.size.width + messagingConfigure.avatarEdge.right + messagingConfigure.textEdge.left, y: messagingConfigure.textEdge.top + nicknameNode.frame.size.height + 3.0)
                }
                textNode.frame = textRect
                backgroundNode.image = sender.isOwnSender ? messagingConfigure.textBackgroundSender : messagingConfigure.textBackgroundReceiver
                backgroundNode.frame = CGRect(x: textRect.origin.x - messagingConfigure.textEdge.left,
                    y: textRect.origin.y - messagingConfigure.textEdge.top,
                    width: textRect.size.width + messagingConfigure.textEdge.left + messagingConfigure.textEdge.right,
                    height: textRect.size.height + messagingConfigure.textEdge.top + messagingConfigure.textEdge.bottom * 2)
            }
        }
        
    }
    
}