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
    
    class TextMessageCellNode: PonyChatUI.UserInterface.MessageCellNode, ASTextNodeDelegate {
        
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
                if linkText(item.text) {
                    textNode.delegate = self
                    textNode.userInteractionEnabled = true
                    textNode.linkAttributeNames = ["PCULinkAttributeName"]
                    textNode.attributedString = linkedAttributedString(attributedString)
                }
                else {
                    textNode.attributedString = attributedString
                }
            }
        }
        
        func linkText(text: String) -> Bool {
            do {
                let detector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
                return detector.numberOfMatchesInString(text, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, text.characters.count)) > 0
            }
            catch _ {
                return false
            }
        }
        
        func linkedAttributedString(text: NSAttributedString) -> NSAttributedString {
            var string = text.string
            string = string.stringByReplacingOccurrencesOfString("[^\\x00-\\xff]", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
            let mutableString = text.mutableCopy()
            do {
                let detector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
                let matches = detector.matchesInString(string, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, string.characters.count))
                for result in matches {
                    if result.resultType == NSTextCheckingType.Link, let URL = result.URL {
                        mutableString.addAttribute("PCULinkAttributeName", value: URL, range: result.range)
                        mutableString.addAttribute(NSForegroundColorAttributeName,
                            value: UIColor(red: 0, green: 95.0/255.0, blue: 1.0, alpha: 1.0),
                            range: result.range)
                    }
                }
            }
            catch _ {}
            return mutableString.copy() as! NSAttributedString
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
                    textRect.origin = CGPoint(x: avatarNode.frame.origin.x - messagingConfigure.avatarEdge.left - textRect.size.width - messagingConfigure.textEdge.right, y: messagingConfigure.textEdge.top + nicknameNode.frame.size.height + messagingConfigure.avatarEdge.top)
                }
                else {
                    textRect.origin = CGPoint(x: avatarNode.frame.origin.x + avatarNode.frame.size.width + messagingConfigure.avatarEdge.right + messagingConfigure.textEdge.left, y: messagingConfigure.textEdge.top + nicknameNode.frame.size.height + messagingConfigure.avatarEdge.top)
                }
                textNode.frame = textRect
                backgroundNode.image = sender.isOwnSender ? messagingConfigure.textBackgroundSender : messagingConfigure.textBackgroundReceiver
                backgroundNode.frame = CGRect(x: textRect.origin.x - messagingConfigure.textEdge.left,
                    y: textRect.origin.y - messagingConfigure.textEdge.top,
                    width: textRect.size.width + messagingConfigure.textEdge.left + messagingConfigure.textEdge.right,
                    height: textRect.size.height + messagingConfigure.textEdge.top + messagingConfigure.textEdge.bottom * 2)
                mainContentRect = backgroundNode.frame
                layoutSendingNodes()
            }
        }
        
        func textNode(textNode: ASTextNode!, shouldHighlightLinkAttribute attribute: String!, value: AnyObject!, atPoint point: CGPoint) -> Bool {
            return true
        }
        
        func textNode(textNode: ASTextNode!, shouldLongPressLinkAttribute attribute: String!, value: AnyObject!, atPoint point: CGPoint) -> Bool {
            return true
        }
        
        func textNode(textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: AnyObject!, atPoint point: CGPoint, textRange: NSRange) {
            if let coreDelegate = coreDelegate, let URL = value as? NSURL {
                coreDelegate.chatUIRequestOpenURL(URL)
            }
        }
        
    }
    
}