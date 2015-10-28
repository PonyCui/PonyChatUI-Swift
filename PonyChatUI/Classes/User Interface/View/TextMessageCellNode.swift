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
            addSubnode(backgroundNode)
            addSubnode(textNode)
        }
        
        override func configureDatas() {
            super.configureDatas()
            configureTextNode()
        }
        
        func configureTextNode() {
            if let item = typedMessageItem {
                let attributedString = NSAttributedString(string: item.text,
                    attributes: Define.sharedDefine.kTextStyle)
                textNode.attributedString = attributedString
            }
        }
        
        override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
            let superSize = super.calculateSizeThatFits(constrainedSize)
            let textBoxWidth = constrainedSize.width - Define.sharedDefine.kAvatarSize.width - Define.sharedDefine.kAvatarEdge.left - Define.sharedDefine.kAvatarEdge.right - Define.sharedDefine.kTextEdge.left - Define.sharedDefine.kTextEdge.right - 60.0
            let textSize = self.textNode.measure(CGSize(width: textBoxWidth, height: constrainedSize.height))
            let requiredHeight = max(superSize.height, textSize.height + Define.sharedDefine.kTextEdge.top + Define.sharedDefine.kTextEdge.bottom)
            contentNode.frame = CGRectMake(0, 0, constrainedSize.width, requiredHeight + Define.sharedDefine.kCellGaps)
            return CGSize(width: constrainedSize.width, height: requiredHeight + Define.sharedDefine.kCellGaps)
        }
        
        override func layout() {
            super.layout()
            if let sender = messageItem.messageSender {
                var textRect = CGRect()
                textRect.size = self.textNode.calculatedSize
                if sender.isOwnSender {
                    textRect.origin = CGPoint(x: avatarNode.frame.origin.x - Define.sharedDefine.kAvatarEdge.left - textRect.size.width - Define.sharedDefine.kTextEdge.right, y: Define.sharedDefine.kTextEdge.top + 3.0)
                }
                else {
                    textRect.origin = CGPoint(x: avatarNode.frame.origin.x + avatarNode.frame.size.width + Define.sharedDefine.kAvatarEdge.right + Define.sharedDefine.kTextEdge.left, y: Define.sharedDefine.kTextEdge.top + 3.0)
                }
                textNode.frame = textRect
                backgroundNode.image = sender.isOwnSender ? Define.sharedDefine.kTextBackgroundSender : Define.sharedDefine.kTextBackgroundReceiver
                backgroundNode.frame = CGRect(x: textRect.origin.x - Define.sharedDefine.kTextEdge.left,
                    y: textRect.origin.y - Define.sharedDefine.kTextEdge.top,
                    width: textRect.size.width + Define.sharedDefine.kTextEdge.left + Define.sharedDefine.kTextEdge.right,
                    height: textRect.size.height + Define.sharedDefine.kTextEdge.top + Define.sharedDefine.kTextEdge.bottom * 2)
            }
        }
        
    }
    
}