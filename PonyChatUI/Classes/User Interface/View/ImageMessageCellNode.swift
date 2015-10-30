//
//  ImageMessageCellNode.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/30.
//
//

import Foundation
import AsyncDisplayKit
import FLAnimatedImage
import SDWebImage

extension PonyChatUI.UserInterface {
    
    class ImageMessageCellNode: MessageCellNode {
        
        let imageNode = ASDisplayNode { () -> UIView! in
            return FLAnimatedImageView()
        }
        
        var typedMessageItem: PonyChatUI.Entity.ImageMessage? {
            if let messageItem = messageItem as? PonyChatUI.Entity.ImageMessage {
                return messageItem
            }
            else {
                return nil
            }
        }
        
        override func configureNodes() {
            super.configureNodes()
            contentNode.addSubnode(imageNode)
        }
        
        override func configureDatas() {
            super.configureDatas()
        }
        
        override func configureResumeStates() {
            if let messageItem = self.typedMessageItem {
                if let thumbURLString = messageItem.thumbURLString {
                    if let URL = NSURL(string: thumbURLString) {
                        SDWebImageDownloader.sharedDownloader().downloadImageWithURL(URL, options: SDWebImageDownloaderOptions(), progress: nil, completed: { (loadedImage, loadedData, _, _) -> Void in
                            if loadedData != nil, let animateImage = FLAnimatedImage(GIFData: loadedData) {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    if let imageView = self.imageNode.view as? FLAnimatedImageView {
                                        imageView.animatedImage = animateImage
                                        self.imageNode.layer.mask = nil
                                        self.imageNode.layer.masksToBounds = false
                                    }
                                })
                            }
                            else if loadedImage != nil {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    if let imageView = self.imageNode.view as? FLAnimatedImageView {
                                        imageView.image = loadedImage
                                    }
                                })
                            }
                        })
                    }
                }
            }
        }
        
        override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
            let superSize = super.calculateSizeThatFits(constrainedSize)
            if let imageSize = imageNodeSize() {
                print(imageSize.height)
                return CGSizeMake(superSize.width, imageSize.height + messagingConfigure.avatarEdge.top + messagingConfigure.cellGaps + nicknameHeight)
            }
            else {
                return superSize
            }
        }
        
        override func layout() {
            super.layout()
            if let messageItem = self.typedMessageItem, let _imageNodeSize = imageNodeSize() {
                if let sender = messageItem.messageSender {
                    if sender.isOwnSender {
                        imageNode.frame = CGRect(x: avatarNode.frame.origin.x - _imageNodeSize.width - messagingConfigure.avatarEdge.left, y: nicknameHeight + messagingConfigure.avatarEdge.top, width: _imageNodeSize.width, height: _imageNodeSize.height)
                        imageNode.layer.mask = self.imageNodeSenderShape(imageNode.frame.size)
                        imageNode.layer.masksToBounds = true
                    }
                    else {
                        imageNode.frame = CGRect(x: avatarNode.frame.origin.x + avatarNode.frame.size.width + messagingConfigure.avatarEdge.right, y: nicknameHeight + messagingConfigure.avatarEdge.top, width: _imageNodeSize.width, height: _imageNodeSize.height)
                        imageNode.layer.mask = self.imageNodeReceiverShape(imageNode.frame.size)
                        imageNode.layer.masksToBounds = true
                    }
                }
                
            }
        }
        
        func imageNodeSize() -> CGSize? {
            let maxWidth = UIScreen.mainScreen().bounds.size.width / 2.0
            let maxHeight = maxWidth * (16.0 / 9.0)
            if let messageItem = self.typedMessageItem where !CGSizeEqualToSize(messageItem.imageSize, CGSizeZero) {
                let imageAR = messageItem.imageSize.height / messageItem.imageSize.width
                let maxAR = maxHeight / maxWidth
                if messageItem.imageSize.width < maxWidth && messageItem.imageSize.height < maxHeight {
                    return messageItem.imageSize
                }
                else if imageAR > maxAR {
                    return CGSize(width: maxHeight / imageAR, height: maxHeight)
                }
                else {
                    return CGSize(width: maxWidth, height: maxWidth * imageAR)
                }
            }
            return nil
        }
        
        func imageNodeSenderShape(size: CGSize) -> CAShapeLayer {
            let bezierPath = UIBezierPath()
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width - 5, height: size.height - 0),
                cornerRadius: 4)
            bezierPath.appendPath(rectanglePath)
            
            let drawPath = UIBezierPath()
            drawPath.moveToPoint(CGPoint(x: size.width - 5, y: 22.5))
            drawPath.addLineToPoint(CGPoint(x: size.width - 0, y: 28.15))
            drawPath.addLineToPoint(CGPoint(x: size.width - 5, y: 34.5))
            drawPath.addLineToPoint(CGPoint(x: size.width - 5, y: 22.5))
            
            bezierPath.appendPath(drawPath)
            bezierPath.closePath()
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierPath.CGPath
            return maskLayer
        }
        
        func imageNodeReceiverShape(size: CGSize) -> CAShapeLayer {
            let bezierPath = UIBezierPath()
            let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 5, y: 0, width: size.width - 5, height: size.height - 0),
                cornerRadius: 4)
            bezierPath.appendPath(rectanglePath)
            
            let drawPath = UIBezierPath()
            drawPath.moveToPoint(CGPoint(x: 5, y: 22.5))
            drawPath.addLineToPoint(CGPoint(x: 0, y: 28.15))
            drawPath.addLineToPoint(CGPoint(x: 5, y: 34.5))
            drawPath.addLineToPoint(CGPoint(x: 5, y: 22.5))
            
            bezierPath.appendPath(drawPath)
            bezierPath.closePath()
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = bezierPath.CGPath
            return maskLayer
        }
        
    }
    
}