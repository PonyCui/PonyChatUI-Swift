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
        
        struct Sender {
            var isOwnSender: Bool = false
            var senderID: String = ""
            var senderNickname: String = "" {
                didSet {
                    if let userInterface = userInterface {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            userInterface.configureDatas()
                        })
                    }
                }
            }
            var senderAvatarURLString: String = "" {
                didSet {
                    if let userInterface = userInterface {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            userInterface.configureDatas()
                        })
                    }
                }
            }
            weak var userInterface: PonyChatUI.UserInterface.MessageCellNode?
        }
        
        enum SendingStatus {
            case None;
            case Sending;
            case Failure;
        }
        
        let messageID: String
        let messageDate: NSDate
        var messageOreder: Double = 0.0
        var messageSender: Sender? = nil
        var messageSendingStatus: Int = 0
        var messageAttributes = [String: Any]()
        
        init(mID: String, mDate: NSDate) {
            messageID = mID
            messageDate = mDate
        }
        
    }
    
    public class TextMessage: Message {
        
        let text: String
        
        init(mID: String, mDate: NSDate, text: String) {
            self.text = text
            super.init(mID: mID, mDate: mDate)
        }
        
    }
    
    public class SystemMessage: TextMessage {}
    
    public class VoiceMessage: Message {
        
        let voiceURLString: String
        let voiceDuration: String
        
        init(mID: String, mDate: NSDate, voiceURLString: String, voiceDuration: String) {
            self.voiceURLString = voiceURLString
            self.voiceDuration = voiceDuration
            super.init(mID: mID, mDate: mDate)
        }
        
    }
    
    public class ImageMessage: Message {
        
        let imageURLString: String
        let thumbURLString: String?
        let imageSize: CGSize
        let isGIF: Bool
        
        init(mID: String, mDate: NSDate, imageURLString: String, thumbURLString: String?, imageSize: CGSize, isGIF: Bool = false) {
            self.imageURLString = imageURLString
            self.thumbURLString = thumbURLString
            self.imageSize = imageSize
            self.isGIF = isGIF
            super.init(mID: mID, mDate: mDate)
        }
        
    }
    
}