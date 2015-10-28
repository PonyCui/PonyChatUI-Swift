//
//  ImageCacheManager.swift
//  PonyChatUIProject
//
//  Created by 崔 明辉 on 15/10/28.
//
//

import Foundation
import AsyncDisplayKit
import SDWebImage

extension PonyChatUI {
    
    class ImageCacheManager: NSObject, ASImageCacheProtocol {
        
        private static let sharedInstance = ImageCacheManager()
        
        internal class var sharedManager: ImageCacheManager {
            return sharedInstance
        }
        
        func fetchCachedImageWithURL(URL: NSURL!, callbackQueue: dispatch_queue_t!, completion: ((CGImage!) -> Void)!) {
            if URL != nil && SDWebImageManager.sharedManager().cachedImageExistsForURL(URL) {
                let cachedImageKey = SDWebImageManager.sharedManager().cacheKeyForURL(URL)
                let memoryCachedImage = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(cachedImageKey)
                if memoryCachedImage != nil {
                    dispatch_async(callbackQueue) { () -> Void in
                        completion(memoryCachedImage.CGImage)
                    }
                    return
                }
                else {
                    let diskCacheImage = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(cachedImageKey)
                    if diskCacheImage != nil {
                        dispatch_async(callbackQueue) { () -> Void in
                            completion(diskCacheImage.CGImage)
                        }
                        return
                    }
                }
            }
            dispatch_async(callbackQueue) { () -> Void in
                completion(nil)
            }
        }
        
    }
    
}