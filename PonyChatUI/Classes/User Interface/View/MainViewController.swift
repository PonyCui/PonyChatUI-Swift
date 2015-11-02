//
//  MainViewController.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation
import AsyncDisplayKit

extension PonyChatUI.UserInterface {
    
    public class MainViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate {
        
        public let eventHandler = MainPresenter()
        
        public weak var coreDelegate: PonyChatUIDelegate? {
            didSet {
                for node in messagingView.visibleNodes() {
                    if let node = node as? MessageCellNode {
                        node.coreDelegate = self.coreDelegate
                    }
                }
            }
        }
        
        var messagingConfigure: Configure = Configure.sharedConfigure
        
        let messagingView: ASTableView = ASTableView()
        var messagingRows: Int = 0
        
        public var footerView: UIView?
        public var footerViewHeight: CGFloat = 0.0 {
            didSet {
                
            }
        }
        
        deinit {
            messagingView.asyncDelegate = nil
            messagingView.asyncDataSource = nil
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            eventHandler.userInterface = self
            configureMessagingView()
            view.addSubview(messagingView)
            if let footerView = footerView {
                view.addSubview(footerView)
            }
        }
        
        override public func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            if UIView.areAnimationsEnabled() {
                UIView.setAnimationsEnabled(true)
            }
        }
        
        override public func viewWillLayoutSubviews() {
            if let footerView = footerView {
                messagingView.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.size.width, height: view.bounds.size.height - footerViewHeight)
                footerView.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + view.bounds.size.height - footerViewHeight, width: view.frame.size.width, height: footerViewHeight)
            }
            else {
                messagingView.frame = view.bounds
            }
        }
        
        public func layoutSubviewsWithAnimation() {
            if let footerView = footerView {
                UIView.animateKeyframesWithDuration(0.3, delay: 0.0, options: [],
                    animations: { () -> Void in
                        self.messagingView.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height - self.footerViewHeight)
                        footerView.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y + self.view.bounds.size.height - self.footerViewHeight, width: self.view.bounds.size.width, height: self.footerViewHeight)
                        self.tableViewAutoScroll(force: true, animated: true)
                    },
                    completion: { (_) -> Void in
                        self.messagingView.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.size.width, height: self.view.bounds.size.height - self.footerViewHeight)
                        footerView.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y + self.view.bounds.size.height - self.footerViewHeight, width: self.view.bounds.size.width, height: self.footerViewHeight)
                        self.tableViewAutoScroll(force: true, animated: true)
                })
            }
        }
        
        func configureMessagingView() {
            messagingView.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 8.0, right: 0.0)
            messagingView.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
            messagingView.asyncDelegate = self
            messagingView.asyncDataSource = self
            messagingView.separatorStyle = .None
            messagingView.frame = self.view.bounds
            messagingView.reloadDataWithCompletion({ () -> Void in
                self.tableViewAutoScroll(force: true, animated: false)
            })
        }
        
        public func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
            if let items = eventHandler.interactor.manager?.items {
                messagingRows = items.count
                return items.count
            }
            return 0
        }
        
        public func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
            return 1
        }
        
        public func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
            if let items = eventHandler.interactor.manager?.items {
                if indexPath.row < items.count {
                    let messageItem = items[indexPath.row]
                    if let messageItem = messageItem as? PonyChatUI.Entity.SystemMessage {
                        return SystemMessageCellNode(messageItem: messageItem,
                            messagingConfigure: self.messagingConfigure)
                    }
                    else if let messageItem = messageItem as? PonyChatUI.Entity.TextMessage {
                        return TextMessageCellNode(messageItem: messageItem,
                            messagingConfigure: self.messagingConfigure)
                    }
                    else if let messageItem = messageItem as? PonyChatUI.Entity.VoiceMessage {
                        return VoiceMessageCellNode(messageItem: messageItem,
                            messagingConfigure: self.messagingConfigure)
                    }
                    else if let messageItem = messageItem as? PonyChatUI.Entity.ImageMessage {
                        return ImageMessageCellNode(messageItem: messageItem,
                            messagingConfigure: self.messagingConfigure)
                    }
                    else {
                        return MessageCellNode(messageItem: messageItem,
                            messagingConfigure: self.messagingConfigure)
                    }
                }
            }
            return ASCellNode()
        }
        
        public func tableView(tableView: ASTableView!, willDisplayNodeForRowAtIndexPath indexPath: NSIndexPath!) {
            for node in tableView.visibleNodes() {
                if let node = node as? MessageCellNode {
                    node.coreDelegate = self.coreDelegate
                    node.messagingViewController = self
                    node.configureResumeStates()
                }
            }
            if indexPath.row == 0 && (messagingView.tracking || messagingView.dragging || messagingView.decelerating) {
                if let manager = eventHandler.interactor.manager where manager.canFetchPreviousItems {
                    messagingView.automaticallyAdjustsContentOffset = true
                    manager.beginFetchPreviousItems()
                    tableViewBeginLoadingItems()
                }
            }
        }
        
        public func scrollViewDidScrollToTop(scrollView: UIScrollView) {
            if let manager = eventHandler.interactor.manager where manager.canFetchPreviousItems {
                messagingView.automaticallyAdjustsContentOffset = true
                manager.beginFetchPreviousItems()
                tableViewBeginLoadingItems()
            }
        }
        
        func tableViewInsertRows(count: Int) {
            if messagingRows == 0 {
                messagingView.reloadDataWithCompletion({ () -> Void in
                    self.tableViewAutoScroll()
                })
                return
            }
            messagingView.beginUpdates()
            for i in 0..<count {
                let index = NSIndexPath(forRow: i, inSection: 0)
                messagingView.insertRowsAtIndexPaths([index], withRowAnimation: .None)
            }
            if let items = eventHandler.interactor.manager?.items {
                messagingRows = items.count
            }
            messagingView.endUpdatesAnimated(false) { (_) -> Void in
            }
        }
        
        func tableViewAppendRows(count: Int) {
            if messagingRows == 0 {
                messagingView.reloadDataWithCompletion({ () -> Void in
                    self.tableViewAutoScroll()
                })
                return
            }
            messagingView.beginUpdates()
            for i in 0..<count {
                let index = NSIndexPath(forRow: messagingRows + i, inSection: 0)
                messagingView.insertRowsAtIndexPaths([index], withRowAnimation: .None)
            }
            if let items = eventHandler.interactor.manager?.items {
                messagingRows = items.count
            }
            messagingView.endUpdatesAnimated(true) { (_) -> Void in
                self.tableViewAutoScroll()
            }
        }
        
        func tableViewRemoveRow(atIndex: Int) {
            messagingView.beginUpdates()
            messagingView.deleteRowsAtIndexPaths([NSIndexPath(forRow: atIndex, inSection: 0)], withRowAnimation: .None)
            if let items = eventHandler.interactor.manager?.items {
                messagingRows = items.count
            }
            messagingView.endUpdatesAnimated(true) { (_) -> Void in
            }
        }
        
        func tableViewAutoScroll(force force: Bool = false, animated: Bool = true) {
            if messagingView.tracking {
                return
            }
            if let firstIndexPath = messagingView.indexPathsForVisibleRows?.first {
                if messagingRows - firstIndexPath.row > 30 && !force {
                    return
                }
            }
            messagingView.scrollToRowAtIndexPath(NSIndexPath(forRow: messagingRows - 1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
        
        func tableViewBeginLoadingItems() {
            let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: messagingView.bounds.width, height: 44))
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            tableHeaderView.addSubview(activityIndicator)
            activityIndicator.center = CGPoint(x: tableHeaderView.bounds.size.width / 2.0, y: tableHeaderView.bounds.size.height / 2.0 - 8.0)
            activityIndicator.startAnimating()
            messagingView.tableHeaderView = tableHeaderView
        }
        
        func tableViewEndLoadingItems() {
            messagingView.tableHeaderView = nil
            messagingView.automaticallyAdjustsContentOffset = false
        }
        
    }
    
}
