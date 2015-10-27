//
//  MessageCellNode.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation
import AsyncDisplayKit

extension PonyChatUI.UserInterface {
    
    public class MessageCellNode: ASCellNode {
        
        let messageItem: PonyChatUI.Entity.Message
        
        let avatarNode = ASNetworkImageNode()
        let contentNode = ASDisplayNode()
        
        init(messageItem: PonyChatUI.Entity.Message) {
            self.messageItem = messageItem
            super.init()
            configureNodes()
            configureDatas()
        }
        
        func configureNodes() {
            addSubnode(contentNode)
            contentNode.addSubnode(avatarNode)
        }
        
        func configureDatas() {
            if let sender = messageItem.messageSender {
                if let URL = NSURL(string: sender.senderAvatarURLString) {
                    avatarNode.URL = URL
                }
            }
        }
        
        public override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
            contentNode.frame = CGRect(x: 0, y: 0, width: constrainedSize.width, height: kAvatarSize.height)
            return CGSize(width: constrainedSize.width, height: kAvatarSize.height + kCellGaps)
        }
        
        public override func layout() {
            if let sender = messageItem.messageSender {
                if sender.isOwnSender {
                    avatarNode.frame = CGRect(x: calculatedSize.width - kAvatarEdge.right, y: kAvatarEdge.top, width: kAvatarSize.width, height: kAvatarSize.height)
                }
                else {
                    avatarNode.frame = CGRect(x: kAvatarEdge.left, y: kAvatarEdge.top, width: kAvatarSize.width, height: kAvatarSize.height)
                }
                avatarNode.layer.cornerRadius = kAvatarCornerRadius
                avatarNode.layer.masksToBounds = true
            }
            else {
                avatarNode.hidden = true
            }
        }
        
    }
    
}