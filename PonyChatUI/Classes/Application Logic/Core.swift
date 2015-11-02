//
//  Core.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

public protocol PonyChatUIDelegate: NSObjectProtocol {
    
    func chatUIRequestOpenURL(URL: NSURL) -> Void
    
    func chatUIRequestOpenLargeImage(messageItem: PonyChatUI.Entity.ImageMessage, originRect: CGRect) -> Void
    
    func chatUIRequestPlayVoiceMessages(messageItems: [PonyChatUI.Entity.VoiceMessage]) -> Void
    
    func chatUIRequestPauseVoicePlaying(messageItem: PonyChatUI.Entity.VoiceMessage) -> Void
    
    func chatUIRequestOpenUserPage(user: PonyChatUI.Entity.Message.Sender) -> Void
    
    func chatUIRequestResendMessage(messageItem: PonyChatUI.Entity.Message) -> Void
    
}

@objc public class PonyChatUICore: NSObject {
    
    private static let sharedInstacne = PonyChatUICore()
    
    public class var sharedCore: PonyChatUICore {
        return sharedInstacne
    }
    
    public let wireframe = PonyChatUI.UserInterface.Wireframe()
    
}