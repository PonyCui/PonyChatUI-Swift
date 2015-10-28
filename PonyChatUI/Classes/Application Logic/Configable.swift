//
//  Configable.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

extension PonyChatUI.UserInterface {
    
    public struct Define {
        
        public var kCellGaps: CGFloat = 8.0
        
        public var kAvatarSize = CGSize(width: CGFloat(40.0), height: CGFloat(40.0))
        public var kAvatarEdge = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        public var kAvatarCornerRadius: CGFloat = 0.0
        
        public var kTextStyle = [String: AnyObject]()
        public var kTextEdge = UIEdgeInsets(top: 12, left: 18, bottom: 10, right: 18)
        public var kTextBackgroundSender = UIImage(named: "SenderTextNodeBkg", inBundle: NSBundle(identifier: "PonyChatUI"), compatibleWithTraitCollection: nil)!.resizableImageWithCapInsets(UIEdgeInsets(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .Stretch)
        public var kTextBackgroundReceiver = UIImage(named: "ReceiverTextNodeBkg", inBundle: NSBundle(identifier: "PonyChatUI"), compatibleWithTraitCollection: nil)!.resizableImageWithCapInsets(UIEdgeInsets(top: 28, left: 20, bottom: 15, right: 20), resizingMode: .Stretch)
        
        static var sharedDefine: Define = Define()
        
        init() {
            setDefaultTextStyle()
        }
        
        mutating func setDefaultTextStyle() {
            let font = UIFont.systemFontOfSize(16)
            let pStyle = NSMutableParagraphStyle()
            pStyle.paragraphSpacing = 0.25 * font.lineHeight
            pStyle.lineSpacing = 6.0
            pStyle.hyphenationFactor = 1.0
            kTextStyle = [NSFontAttributeName: font, NSParagraphStyleAttributeName: pStyle]
        }
        
    }
    
}