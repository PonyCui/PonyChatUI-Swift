//
//  MainInteractor.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

extension PonyChatUI.UserInterface {
    
    public class MainInteractor {
        
        var manager: PonyChatUI.MessageManager?
        
        weak var delegate: MainPresenter?
        
        func insertedMessages() {
            if let delegate = delegate {

            }
        }
        
        func appendedMessage() {
            if let delegate = delegate {
                
            }
        }
        
    }
    
}