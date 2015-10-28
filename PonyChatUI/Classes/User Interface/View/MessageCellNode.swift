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
        let messagingConfigure: Configure
        
        let avatarNode = ASNetworkImageNode(cache: PonyChatUI.ImageCacheManager.sharedManager,
            downloader: PonyChatUI.ImageDownloadManager.sharedManager)
        let contentNode = ASDisplayNode()
        
        init(messageItem: PonyChatUI.Entity.Message, messagingConfigure: Configure) {
            self.messageItem = messageItem
            self.messagingConfigure = messagingConfigure
            super.init()
            configureNodes()
            configureDatas()
        }
        
        func configureNodes() {
            selectionStyle = .None
            addSubnode(contentNode)
            contentNode.addSubnode(avatarNode)
            if self.messageItem.messageSender != nil {
                self.messageItem.messageSender!.userInterface = self
            }
        }
        
        func configureDatas() {
            if let sender = messageItem.messageSender {
                if let URL = NSURL(string: sender.senderAvatarURLString) {
                    avatarNode.URL = URL
                }
            }
        }
        
        public override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
            contentNode.frame = CGRect(x: 0, y: 0, width: constrainedSize.width, height: messagingConfigure.avatarSize.height + messagingConfigure.avatarEdge.bottom)
            return CGSize(width: constrainedSize.width, height: messagingConfigure.avatarSize.height + messagingConfigure.avatarEdge.bottom + messagingConfigure.cellGaps)
        }
        
        public override func layout() {
            if let sender = messageItem.messageSender {
                if sender.isOwnSender {
                    avatarNode.frame = CGRect(x: calculatedSize.width - messagingConfigure.avatarEdge.right - messagingConfigure.avatarSize.width, y: messagingConfigure.avatarEdge.top, width: messagingConfigure.avatarSize.width, height: messagingConfigure.avatarSize.height)
                }
                else {
                    avatarNode.frame = CGRect(x: messagingConfigure.avatarEdge.left, y: messagingConfigure.avatarEdge.top, width: messagingConfigure.avatarSize.width, height: messagingConfigure.avatarSize.height)
                }
                avatarNode.layer.cornerRadius = messagingConfigure.avatarCornerRadius
                avatarNode.layer.masksToBounds = true
            }
            else {
                avatarNode.hidden = true
            }
        }
        
    }
    
}