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
        
        let avatarNode = ASNetworkImageNode(cache: PonyChatUI.ImageCacheManager.sharedManager,
            downloader: PonyChatUI.ImageDownloadManager.sharedManager)
        let contentNode = ASDisplayNode()
        
        init(messageItem: PonyChatUI.Entity.Message) {
            self.messageItem = messageItem
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
            contentNode.frame = CGRect(x: 0, y: 0, width: constrainedSize.width, height: Define.sharedDefine.kAvatarSize.height + Define.sharedDefine.kAvatarEdge.bottom)
            return CGSize(width: constrainedSize.width, height: Define.sharedDefine.kAvatarSize.height + Define.sharedDefine.kAvatarEdge.bottom + Define.sharedDefine.kCellGaps)
        }
        
        public override func layout() {
            if let sender = messageItem.messageSender {
                if sender.isOwnSender {
                    avatarNode.frame = CGRect(x: calculatedSize.width - Define.sharedDefine.kAvatarEdge.right - Define.sharedDefine.kAvatarSize.width, y: Define.sharedDefine.kAvatarEdge.top, width: Define.sharedDefine.kAvatarSize.width, height: Define.sharedDefine.kAvatarSize.height)
                }
                else {
                    avatarNode.frame = CGRect(x: Define.sharedDefine.kAvatarEdge.left, y: Define.sharedDefine.kAvatarEdge.top, width: Define.sharedDefine.kAvatarSize.width, height: Define.sharedDefine.kAvatarSize.height)
                }
                avatarNode.layer.cornerRadius = Define.sharedDefine.kAvatarCornerRadius
                avatarNode.layer.masksToBounds = true
            }
            else {
                avatarNode.hidden = true
            }
        }
        
    }
    
}