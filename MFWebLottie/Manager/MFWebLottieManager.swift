//
//  MFWebLottieManager.swift
//  MFWebLottie
//
//  Created by 杨烁 on 2018/11/30.
//  Copyright © 2018 杨烁. All rights reserved.
//

import UIKit

open class MFWebLottieManager: NSObject {

    /// 配置基地址
    ///  例:https://a.b.c/c
    /// - Parameter path: 基地址
    public func setBasePath(path:String){
        MFDownloadManager.shared.setBasePath(path)
    }
    
    /// 获取缓存大小
    ///
    /// - Returns: 缓存大小
    public func getCacheSize() -> CGFloat{
        return MFCacheManager.shared.getCacheSize()
    }
    
    /// 清除缓存
    public func clearCache(){
        MFCacheManager.shared.clearCache()
    }
    
}
