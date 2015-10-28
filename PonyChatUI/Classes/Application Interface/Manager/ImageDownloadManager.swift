//
//  ImageDownloadManager.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/28.
//
//

import Foundation
import AsyncDisplayKit
import SDWebImage

extension PonyChatUI {
    
    class ImageDownloadManager: NSObject, ASImageDownloaderProtocol {
        
        private static let sharedInstance = ImageDownloadManager()
        
        internal class var sharedManager: ImageDownloadManager {
            return sharedInstance
        }
        
        func downloadImageWithURL(URL: NSURL!, callbackQueue: dispatch_queue_t!, downloadProgressBlock: ((CGFloat) -> Void)!, completion: ((CGImage!, NSError!) -> Void)!) -> AnyObject! {
            let options: SDWebImageOptions = SDWebImageOptions.RetryFailed
            let operation = SDWebImageManager.sharedManager().downloadImageWithURL(URL, options: options, progress: nil) { (theImage, theError, _, _, _) -> Void in
                if theImage != nil {
                    dispatch_async(callbackQueue, { () -> Void in
                        completion(theImage.CGImage, theError)
                    })
                }
                else {
                    dispatch_async(callbackQueue, { () -> Void in
                        completion(nil, theError)
                    })
                }
            }
            return operation
        }
        
        func cancelImageDownloadForIdentifier(downloadIdentifier: AnyObject!) {
            if let downloadIdentifier = downloadIdentifier as? SDWebImageOperation {
                downloadIdentifier.cancel()
            }
        }
        
    }
    
}