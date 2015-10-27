//
//  Wireframe.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/27.
//
//

import Foundation

extension PonyChatUI.UserInterface {
    
    public class Wireframe {
        
        public func main(messageManager: PonyChatUI.MessageManager) -> (PonyChatUI.UserInterface.MainViewController, UIView) {
            let mainViewController = MainViewController()
            mainViewController.eventHandler.interactor.manager = messageManager
            messageManager.delegate = mainViewController.eventHandler.interactor
            return (mainViewController, mainViewController.view)
        }
        
    }
    
}