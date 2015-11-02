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
        
        public var canFetchPreviousItems = false
        
        internal var items: [Entity.Message]? = nil
        
        public init() {
            items = []
        }
        
        public func insertItems(items: [Entity.Message]) {
            if self.items != nil {
                let dateItems = addDateItems(items)
                for item in dateItems.reverse() {
                    self.items!.insert(item, atIndex: 0)
                }
                if let delegate = delegate {
                    delegate.insertedMessages(dateItems.count)
                }
            }
        }
        
        public func appendItem(item: Entity.Message) {
            if self.items != nil {
                let dateItems = addDateItems(self.items!.last, currentItem: item)
                for item in dateItems {
                    self.items!.append(item)
                }
                if let delegate = delegate {
                    delegate.appendedMessage(dateItems.count)
                }
            }
        }
        
        public func deleteItem(item: Entity.Message) {
            if self.items != nil {
                if let itemIndex = self.items!.indexOf({ (arrayItem) -> Bool in
                    return arrayItem.messageID == item.messageID
                }) {
                    self.items!.removeAtIndex(itemIndex)
                    if let delegate = delegate {
                        delegate.deletedMessage(itemIndex)
                    }
                }
            }
        }
        
        private func addDateItems(items: [Entity.Message]) -> [Entity.Message] {
            var lastDate: NSDate?
            var dateItems: [Entity.Message] = []
            for item in items {
                if let lastDate = lastDate where lastDate.timeIntervalSinceDate(item.messageDate) < -300 {
                    dateItems.append(dateItem(item.messageDate))
                }
                else if lastDate == nil {
                    dateItems.append(dateItem(item.messageDate))
                }
                lastDate = item.messageDate
                dateItems.append(item)
            }
            return dateItems
        }
        
        private func addDateItems(lastItem: Entity.Message?, currentItem: Entity.Message) -> [Entity.Message] {
            if let lastItem = lastItem where lastItem.messageDate.timeIntervalSinceDate(currentItem.messageDate) < -300 {
                return [dateItem(currentItem.messageDate), currentItem]
            }
            else if lastItem == nil {
                return [dateItem(currentItem.messageDate), currentItem]
            }
            else {
                return [currentItem]
            }
        }
        
        private func dateItem(date: NSDate) -> Entity.SystemMessage {
            return Entity.SystemMessage(mID: "Date\(date.description)", mDate: date, text: dateDescription(date))
        }
        
        static let timeFormatter = NSDateFormatter()
        static let dateFormatter = NSDateFormatter()
        static let previousDateFormatter = NSDateFormatter()
        private func dateDescription(date: NSDate) -> String {
            MessageManager.timeFormatter.dateFormat = "HH:mm"
            MessageManager.dateFormatter.dateFormat = "MM/dd"
            MessageManager.previousDateFormatter.dateFormat = "MM/dd HH:mm"
            if MessageManager.dateFormatter.stringFromDate(date) == MessageManager.dateFormatter.stringFromDate(NSDate()) {
                return MessageManager.timeFormatter.stringFromDate(date)
            }
            else {
                return MessageManager.previousDateFormatter.stringFromDate(date)
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
                            if let sender = item.messageSender where sender.isOwnSender {
                                continue
                            }
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
        
        public var isFetchingPreviousItems = false
        public func beginFetchPreviousItems() {
            if isFetchingPreviousItems {
                return
            }
            isFetchingPreviousItems = true
        }
        
        public func endFetchPreviousItems() {
            isFetchingPreviousItems = false
        }
        
    }
    
}