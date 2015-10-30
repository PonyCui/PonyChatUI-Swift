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
    
    public class MessageCellNode: ASCellNode, PCUMenuViewControllerDelegate {
        
        weak var coreDelegate: PonyChatUIDelegate?
        weak var messagingViewController: MainViewController?
        
        let messageItem: PonyChatUI.Entity.Message
        let messagingConfigure: Configure
        
        let avatarNode = ASNetworkImageNode(cache: PonyChatUI.ImageCacheManager.sharedManager,
            downloader: PonyChatUI.ImageDownloadManager.sharedManager)
        let nicknameNode = ASTextNode()
        var sendingIndicatorNode: ASDisplayNode? = nil
        var sendingErrorNode: ASImageNode? = nil
        let contentNode = ASDisplayNode()
        
        var longPressGesture: UILongPressGestureRecognizer?
        
        init(messageItem: PonyChatUI.Entity.Message, messagingConfigure: Configure) {
            self.messageItem = messageItem
            self.messagingConfigure = messagingConfigure
            super.init()
            configureNodes()
            configureDatas()
        }
        
        var mainContentRect: CGRect = CGRect()
        func configureNodes() {
            selectionStyle = .None
            addSubnode(contentNode)
            contentNode.userInteractionEnabled = true
            contentNode.addSubnode(avatarNode)
            self.messageItem.userInterface = self
            if self.messageItem.messageSender != nil {
                self.messageItem.messageSender!.userInterface = self
            }
            if self.messagingConfigure.nicknameShow {
                contentNode.addSubnode(nicknameNode)
            }
            longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPressed:")
            longPressGesture!.minimumPressDuration = 0.25
        }
        
        func configureDatas() {
            if let sender = messageItem.messageSender {
                if let URL = NSURL(string: sender.senderAvatarURLString) {
                    avatarNode.URL = URL
                }
                if messagingConfigure.nicknameShow {
                    nicknameNode.attributedString = NSAttributedString(string: sender.senderNickname,
                        attributes: messagingConfigure.nicknameStyle)
                }
                if sender.isOwnSender {
                    configureSendingNodes()
                }
            }
        }
        
        func configureResumeStates() {
            if let sendingIndicatorView = self.sendingIndicatorNode?.view as? UIActivityIndicatorView {
                sendingIndicatorView.startAnimating()
            }
        }
        
        func configureSendingNodes() {
            if messageItem.messageSendingStatus == .Sending {
                self.sendingIndicatorNode = ASDisplayNode(viewBlock: { () -> UIView! in
                    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                    indicatorView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                    indicatorView.startAnimating()
                    return indicatorView
                })
                contentNode.addSubnode(self.sendingIndicatorNode)
                if let errorNode = self.sendingErrorNode {
                    errorNode.removeFromSupernode()
                }
                layoutSendingNodes()
            }
            else if messageItem.messageSendingStatus == .Failure {
                self.sendingErrorNode = ASImageNode()
                self.sendingErrorNode?.image = UIImage(named: "SenderNodeError", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)
                contentNode.addSubnode(self.sendingErrorNode)
                if let indicatorNode = self.sendingIndicatorNode {
                    indicatorNode.removeFromSupernode()
                }
                layoutSendingNodes()
            }
            else {
                if let indicatorNode = self.sendingIndicatorNode {
                    indicatorNode.removeFromSupernode()
                }
                if let errorNode = self.sendingErrorNode {
                    errorNode.removeFromSupernode()
                }
            }
        }
        
        func layoutSendingNodes() {
            if let indicatorNode = self.sendingIndicatorNode {
                indicatorNode.frame = CGRect(x: mainContentRect.origin.x - 44.0, y: mainContentRect.size.height / 2.0 + mainContentRect.origin.y - 22.0 - 4.0, width: 44.0, height: 44.0)
            }
            if let errorNode = self.sendingErrorNode {
                errorNode.frame = CGRect(x: mainContentRect.origin.x - 44.0, y: mainContentRect.size.height / 2.0 + mainContentRect.origin.y - 22.0 - 4.0, width: 44.0, height: 44.0)
            }
        }
        
        var nicknameHeight: CGFloat = 0.0
        public override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
            if messagingConfigure.nicknameShow {
                nicknameNode.measure(constrainedSize)
                nicknameHeight = nicknameNode.calculatedSize.height + messagingConfigure.nicknameEdge.top + messagingConfigure.nicknameEdge.bottom
            }
            contentNode.frame = CGRect(x: 0, y: 0.0, width: constrainedSize.width, height: messagingConfigure.avatarSize.height + messagingConfigure.avatarEdge.bottom + nicknameHeight)
            return CGSize(width: constrainedSize.width, height: messagingConfigure.avatarSize.height + messagingConfigure.avatarEdge.top + messagingConfigure.avatarEdge.bottom + messagingConfigure.cellGaps)
        }
        
        public override func layout() {
            if let sender = messageItem.messageSender {
                if sender.isOwnSender {
                    avatarNode.frame = CGRect(x: calculatedSize.width - messagingConfigure.avatarEdge.right - messagingConfigure.avatarSize.width, y: messagingConfigure.avatarEdge.top, width: messagingConfigure.avatarSize.width, height: messagingConfigure.avatarSize.height)
                    if messagingConfigure.nicknameShow {
                        nicknameNode.frame = CGRect(x: avatarNode.frame.origin.x - messagingConfigure.avatarEdge.left - nicknameNode.calculatedSize.width - messagingConfigure.nicknameEdge.right, y: messagingConfigure.nicknameEdge.top, width: nicknameNode.calculatedSize.width, height: nicknameNode.calculatedSize.height + messagingConfigure.nicknameEdge.bottom)
                    }
                }
                else {
                    avatarNode.frame = CGRect(x: messagingConfigure.avatarEdge.left, y: messagingConfigure.avatarEdge.top, width: messagingConfigure.avatarSize.width, height: messagingConfigure.avatarSize.height)
                    if messagingConfigure.nicknameShow {
                        nicknameNode.frame = CGRect(x: avatarNode.frame.origin.x + messagingConfigure.avatarSize.width + messagingConfigure.avatarEdge.right + messagingConfigure.nicknameEdge.left, y: messagingConfigure.nicknameEdge.top, width: nicknameNode.calculatedSize.width, height: nicknameNode.calculatedSize.height + messagingConfigure.nicknameEdge.bottom)
                    }
                }
                avatarNode.layer.cornerRadius = messagingConfigure.avatarCornerRadius
                avatarNode.layer.masksToBounds = true
            }
            else {
                avatarNode.hidden = true
            }
        }
        
        let _menuViewController = MenuViewController(titles: [])
        func handleLongPressed(sender: UILongPressGestureRecognizer) {
            var titles = _menuViewController.titles
            for item in messagingConfigure.longPressItems {
                titles.append(item.title)
            }
            _menuViewController.titles = titles
            if sender.state == UIGestureRecognizerState.Began {
                _menuViewController.delegate = self
                var thePoint = self.view.convertPoint(mainContentRect.origin, toView: UIApplication.sharedApplication().keyWindow)
                thePoint.x += (mainContentRect.width / 2.0)
                _menuViewController.showMenuView(thePoint)
            }
        }
        
        func menuItemDidPressed(menuViewController: PonyChatUI.UserInterface.MenuViewController, itemIndex: Int) {
            if itemIndex < _menuViewController.titles.count {
                let title = _menuViewController.titles[itemIndex]
                for item in messagingConfigure.longPressItems {
                    if item.title == title {
                        item.executingBlock(message: messageItem)
                    }
                }
            }
        }
        
    }
    
}