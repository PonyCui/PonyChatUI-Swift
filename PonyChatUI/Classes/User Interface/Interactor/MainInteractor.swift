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
        
        func insertedMessages(count: Int) {
            if let delegate = delegate {
                delegate.insertMessage(count)
            }
        }
        
        func appendedMessage() {
            if let delegate = delegate {
                delegate.appendMessage(1)
            }
        }
        
    }
    
}