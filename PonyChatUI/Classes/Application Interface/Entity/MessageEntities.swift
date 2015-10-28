//
//  MessagesEntity.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

extension PonyChatUI.Entity {
    
    public class Message {
        
        public struct Sender {
            public var isOwnSender: Bool = false
            public var senderID: String = ""
            public var senderNickname: String = "" {
                didSet {
                    if let userInterface = userInterface {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            userInterface.configureDatas()
                        })
                    }
                }
            }
            public var senderAvatarURLString: String = "" {
                didSet {
                    if let userInterface = userInterface {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            userInterface.configureDatas()
                        })
                    }
                }
            }
            weak var userInterface: PonyChatUI.UserInterface.MessageCellNode?
            
            public init() {
                
            }
        }
        
        public enum SendingStatus {
            case None;
            case Sending;
            case Failure;
        }
        
        public let messageID: String
        public let messageDate: NSDate
        public var messageOreder: Double = 0.0
        public var messageSender: Sender? = nil
        public var messageSendingStatus: Int = 0
        public var messageAttributes = [String: Any]()
        
        public init(mID: String, mDate: NSDate) {
            messageID = mID
            messageDate = mDate
        }
        
    }
    
    public class TextMessage: Message {
        
        public let text: String
        
        public init(mID: String, mDate: NSDate, text: String) {
            self.text = text
            super.init(mID: mID, mDate: mDate)
        }
        
    }
    
    public class SystemMessage: TextMessage {}
    
    public class VoiceMessage: Message {
        
        public let voiceURLString: String
        public let voiceDuration: String
        
        public init(mID: String, mDate: NSDate, voiceURLString: String, voiceDuration: String) {
            self.voiceURLString = voiceURLString
            self.voiceDuration = voiceDuration
            super.init(mID: mID, mDate: mDate)
        }
        
    }
    
    public class ImageMessage: Message {
        
        public let imageURLString: String
        public let thumbURLString: String?
        public let imageSize: CGSize
        public let isGIF: Bool
        
        public init(mID: String, mDate: NSDate, imageURLString: String, thumbURLString: String?, imageSize: CGSize, isGIF: Bool = false) {
            self.imageURLString = imageURLString
            self.thumbURLString = thumbURLString
            self.imageSize = imageSize
            self.isGIF = isGIF
            super.init(mID: mID, mDate: mDate)
        }
        
    }
    
}