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
        
        let messagingView: ASTableView = ASTableView()
        
        deinit {
            messagingView.asyncDelegate = nil
            messagingView.asyncDataSource = nil
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            configureMessagingView()
            view.addSubview(messagingView)
        }
        
        override public func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            if UIView.areAnimationsEnabled() {
                UIView.setAnimationsEnabled(true)
            }
        }
        
        override public func viewWillLayoutSubviews() {
            messagingView.frame = view.bounds
        }
        
        func configureMessagingView() {
            messagingView.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
            messagingView.asyncDelegate = self
            messagingView.asyncDataSource = self
        }
        
        public func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        public func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
            return 1
        }
        
        public func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
            return ASCellNode()
        }
        
    }
    
}
