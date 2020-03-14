//
//  PHAsset+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/3/2.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit
import Photos

@objc public extension PHAsset{
    
    /// 请求UIImage
    func requestImage(_ resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        let options = PHImageRequestOptions.defaultOptions()
        PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: resultHandler)
    }
    
}

@objc public extension PHImageRequestOptions{
    
    /// 默认参数
    static func defaultOptions() -> PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        return options;
    }

}
