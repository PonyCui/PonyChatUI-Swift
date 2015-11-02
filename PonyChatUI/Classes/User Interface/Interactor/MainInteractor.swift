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
        
        public var manager: PonyChatUI.MessageManager?
        
        weak var delegate: MainPresenter?
        
        func insertedMessages(count: Int) {
            if let delegate = delegate {
                delegate.insertMessage(count)
            }
        }
        
        func appendedMessage(count: Int) {
            if let delegate = delegate {
                delegate.appendMessage(count)
            }
        }
        
        func deletedMessage(atIndex: Int) {
            if let delegate = delegate {
                delegate.removeMessage(atIndex)
            }
        }
        
    }
    
}