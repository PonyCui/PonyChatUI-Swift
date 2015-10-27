//
//  Core.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

@objc public class PonyChatUICore: NSObject {
    
    private static let sharedInstacne = PonyChatUICore()
    
    public class var sharedCore: PonyChatUICore {
        return sharedInstacne
    }
    
    public let wireframe = PonyChatUI.UserInterface.Wireframe()
    
}