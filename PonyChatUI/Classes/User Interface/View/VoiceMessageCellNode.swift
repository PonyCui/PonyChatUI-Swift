//
//  VoiceMessageCellNode.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/29.
//
//

import Foundation
import AsyncDisplayKit

extension PonyChatUI.UserInterface {
    
    class VoiceMessageCellNode: MessageCellNode {
        
        var isPlaying: Bool = false
        
        let voiceNode = ASDisplayNode { () -> UIView! in
            let imageView = UIImageView()
            return imageView
        }
        let backgroundNode = ASImageNode()
        let durationNode = ASTextNode()
        let badgeNode = ASDisplayNode()
        
        var typedMessageItem: PonyChatUI.Entity.VoiceMessage? {
            if let messageItem = messageItem as? PonyChatUI.Entity.VoiceMessage {
                return messageItem
            }
            else {
                return nil
            }
        }
        
        override func configureNodes() {
            super.configureNodes()
            backgroundNode.addTarget(self, action: Selector("handleBackgroundTapped"), forControlEvents: .TouchUpInside)
            contentNode.addSubnode(backgroundNode)
            contentNode.addSubnode(voiceNode)
            contentNode.addSubnode(durationNode)
            contentNode.addSubnode(badgeNode)
            badgeNode.backgroundColor = UIColor.redColor()
            badgeNode.hidden = true
            backgroundNode.view.userInteractionEnabled = true
            if let longPressGesture = longPressGesture {
                backgroundNode.view.addGestureRecognizer(longPressGesture)
            }
        }
        
        override func configureDatas() {
            super.configureDatas()
            if let messageItem = typedMessageItem {
                if let sender = messageItem.messageSender {
                    if sender.isOwnSender {
                        backgroundNode.image = messagingConfigure.textBackgroundSender
                        if let voiceNodeView = voiceNode.view as? UIImageView {
                            voiceNodeView.contentMode = UIViewContentMode.Right
                            voiceNodeView.image = UIImage(named: "SenderVoiceNodePlaying", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)
                        }
                    }
                    else {
                        backgroundNode.image = messagingConfigure.textBackgroundReceiver
                        if let voiceNodeView = voiceNode.view as? UIImageView {
                            voiceNodeView.contentMode = UIViewContentMode.Left
                            voiceNodeView.image = UIImage(named: "ReceiverVoiceNodePlaying", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)
                        }
                        badgeNode.hidden = messageItem.voicePlayed
                    }
                }
                durationNode.attributedString = NSAttributedString(string: "\(Int(ceil(messageItem.voiceDuration + 0.01)))''", attributes: messagingConfigure.nicknameStyle)
            }
        }
        
        func configurePlayedData() {
            if let messageItem = typedMessageItem {
                badgeNode.hidden = messageItem.voicePlayed
            }
        }
        
        override func configureResumeStates() {
            super.configureResumeStates()
            if isPlaying {
                letStatePlay()
            }
            else {
                letStatePause()
            }
        }
        
        override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
            durationNode.measure(constrainedSize)
            var superSize = super.calculateSizeThatFits(constrainedSize)
            superSize.height += nicknameHeight
            return superSize
        }
        
        override func layout() {
            super.layout()
            if let messageItem = typedMessageItem {
                let backgroundWidth = CGFloat(max(88.0, min(260.0, messageItem.voiceDuration / 60.0 * 260.0)))
                if let sender = messageItem.messageSender {
                    if sender.isOwnSender {
                        backgroundNode.frame = CGRect(x: avatarNode.frame.origin.x - messagingConfigure.avatarEdge.left - backgroundWidth, y: 2.0 + nicknameHeight, width: backgroundWidth, height: 54.0)
                        voiceNode.frame = CGRect(x: backgroundNode.frame.origin.x + backgroundNode.frame.size.width - 62.0, y: backgroundNode.frame.origin.y, width: 44.0, height: 44.0)
                        durationNode.frame = CGRect(x: backgroundNode.frame.origin.x - 4.0 - durationNode.calculatedSize.width, y: backgroundNode.frame.origin.y + backgroundNode.frame.size.height - durationNode.calculatedSize.height - 14.0, width: durationNode.calculatedSize.width, height: durationNode.calculatedSize.height)
                        badgeNode.frame = CGRect(x: backgroundNode.frame.origin.x - 4.0 - durationNode.calculatedSize.width, y: backgroundNode.frame.origin.y + 6.0, width: 8.0, height: 8.0)
                        badgeNode.layer.cornerRadius = 4.0
                    }
                    else {
                        backgroundNode.frame = CGRect(x: avatarNode.frame.origin.x + avatarNode.frame.size.width + messagingConfigure.avatarEdge.right, y: 2.0 + nicknameHeight, width: backgroundWidth, height: 54.0)
                        voiceNode.frame = CGRect(x: backgroundNode.frame.origin.x + 20.0, y: backgroundNode.frame.origin.y, width: 44.0, height: 44.0)
                        durationNode.frame = CGRect(x: backgroundNode.frame.origin.x + backgroundNode.frame.size.width + 4.0, y: backgroundNode.frame.origin.y + backgroundNode.frame.size.height - durationNode.calculatedSize.height - 14.0, width: durationNode.calculatedSize.width, height: durationNode.calculatedSize.height)
                        badgeNode.frame = CGRect(x: backgroundNode.frame.origin.x + backgroundNode.frame.size.width + 4.0, y: backgroundNode.frame.origin.y + 6.0, width: 8.0, height: 8.0)
                        badgeNode.layer.cornerRadius = 4.0
                    }
                    mainContentRect = backgroundNode.frame
                }
            }
        }
        
        func handleBackgroundTapped() {
            if let coreDelegate = coreDelegate {
                if let messageItem = self.typedMessageItem {
                    if messageItem.voicePlaying {
                        coreDelegate.chatUIRequestPauseVoicePlaying(messageItem)
                    }
                    else {
                        if let messagingViewController = messagingViewController,
                            let manager = messagingViewController.eventHandler.interactor.manager {
                                coreDelegate.chatUIRequestPlayVoiceMessages(manager.nextVoiceMessages(messageItem))
                        }
                        else {
                            coreDelegate.chatUIRequestPlayVoiceMessages([messageItem])
                        }
                    }
                }
            }
        }
        
        func letStatePlay() {
            if let messageItem = typedMessageItem {
                if let sender = messageItem.messageSender {
                    if sender.isOwnSender {
                        backgroundNode.image = messagingConfigure.textBackgroundSender
                        if let voiceNodeView = voiceNode.view as? UIImageView {
                            voiceNodeView.contentMode = UIViewContentMode.Right
                            voiceNodeView.animationImages = [
                                UIImage(named: "SenderVoiceNodePlaying001", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!,
                                UIImage(named: "SenderVoiceNodePlaying002", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!,
                                UIImage(named: "SenderVoiceNodePlaying003", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!
                            ]
                            voiceNodeView.animationDuration = 1.0
                            voiceNodeView.startAnimating()
                        }
                    }
                    else {
                        backgroundNode.image = messagingConfigure.textBackgroundReceiver
                        if let voiceNodeView = voiceNode.view as? UIImageView {
                            voiceNodeView.contentMode = UIViewContentMode.Left
                            voiceNodeView.animationImages = [
                                UIImage(named: "ReceiverVoiceNodePlaying001", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!,
                                UIImage(named: "ReceiverVoiceNodePlaying002", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!,
                                UIImage(named: "ReceiverVoiceNodePlaying003", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!
                            ]
                            voiceNodeView.animationDuration = 1.0
                            voiceNodeView.startAnimating()
                        }
                    }
                }
            }
        }
        
        func letStatePause() {
            if let messageItem = typedMessageItem {
                if let sender = messageItem.messageSender {
                    if sender.isOwnSender {
                        backgroundNode.image = messagingConfigure.textBackgroundSender
                        if let voiceNodeView = voiceNode.view as? UIImageView {
                            voiceNodeView.contentMode = UIViewContentMode.Right
                            voiceNodeView.animationImages = nil
                            voiceNodeView.animationImages = [
                                UIImage(named: "SenderVoiceNodePlaying", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!
                            ]
                            voiceNodeView.stopAnimating()
                        }
                    }
                    else {
                        backgroundNode.image = messagingConfigure.textBackgroundReceiver
                        if let voiceNodeView = voiceNode.view as? UIImageView {
                            voiceNodeView.contentMode = UIViewContentMode.Left
                            voiceNodeView.animationImages = nil
                            voiceNodeView.animationImages = [
                                UIImage(named: "ReceiverVoiceNodePlaying", inBundle: NSBundle(forClass: PonyChatUICore.self), compatibleWithTraitCollection: nil)!
                            ]
                            voiceNodeView.stopAnimating()
                        }
                    }
                }
            }
        }
        
        override func handleLongPressed(sender: UILongPressGestureRecognizer) {
            _menuViewController.titles = []
            super.handleLongPressed(sender)
        }
        
    }
    
}