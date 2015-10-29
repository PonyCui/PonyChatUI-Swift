//
//  MessageManager.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

extension PonyChatUI {
    
    public class MessageManager {
        
        internal weak var delegate: PonyChatUI.UserInterface.MainInteractor?
        
        internal var items: [Entity.Message]? = nil
        
        public init() {
            items = []
        }
        
        public func insertItems(items: [Entity.Message]) {
            if self.items != nil {
                self.items!.insertContentsOf(items, at: 0)
                if let delegate = delegate {
                    delegate.insertedMessages(items.count)
                }
            }
        }
        
        public func appendItem(item: Entity.Message) {
            if self.items != nil {
                self.items!.append(item)
                if let delegate = delegate {
                    delegate.appendedMessage()
                }
            }
        }
        
        internal func nextVoiceMessages(from: Entity.VoiceMessage) -> [Entity.VoiceMessage] {
            var nextItems: [Entity.VoiceMessage] = []
            if let items = self.items {
                var founded = false
                for item in items {
                    if let item = item as? Entity.VoiceMessage {
                        if item.messageID == from.messageID {
                            founded = true
                            nextItems.append(item)
                            continue
                        }
                        if !founded {
                            continue
                        }
                        if !item.voicePlayed {
                            nextItems.append(item)
                        }
                        else {
                            break
                        }
                    }
                }
            }
            return nextItems
        }
        
    }
    
}