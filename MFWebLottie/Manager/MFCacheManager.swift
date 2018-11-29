//
//  CacheManager.swift
//  MFWebLottie
//
//  Created by 杨烁 on 2018/11/29.
//  Copyright © 2018 杨烁. All rights reserved.
//

import UIKit

let mfCacheInfoPath = mfResourceRootPath + "/cacheInfo.plist"

class MFCacheManager: NSObject {

    static let shared = MFCacheManager()
    
    var cacheInfo: [String: Bool] = [String: Bool]()
   
    // 重载并私有
    private override init() {
        // 初始化一些内容
        super.init()
        self.loadCacheInfo()
    }
    
    ///加载缓存信息
    private func loadCacheInfo(){
        guard let localInfo = NSDictionary.init(contentsOfFile: mfCacheInfoPath) as? [String: Bool] else{
            return
        }
        self.cacheInfo = localInfo
    }

    /// 更新缓存信息
    ///
    /// - Parameters:
    ///   - key: 压缩文件的MD5
    ///   - hasUnzip: 是否已经解压
    func updateCacheInfo(key:String, hasZip:Bool){
        self.cacheInfo = [key : hasZip]
        NSDictionary.init(dictionary: self.cacheInfo).write(toFile: mfCacheInfoPath, atomically: true)
    }
    
    
    /// 判断是否有缓存
    ///
    /// - Parameter key: 压缩文件的MD5
    /// - Returns: 是否存在
    func isExistInCache(key:String) -> Bool{
        return self.cacheInfo[key] ?? false
    }
    
    
    /// 遍历resource目录,返回缓存大小单位:M
    ///
    /// - Returns: 返回单位例如0.46840343M
   public func getCacheSize() -> CGFloat {
        let folderPath = NSString.init(string: mfResourceRootPath)
        let manager = FileManager.default
        if manager.fileExists(atPath: mfResourceRootPath) {
            let childFilesEnumerator = manager.enumerator(atPath: mfResourceRootPath)
            var fileName = ""
            var folderSize: UInt64 = 0

            
            while childFilesEnumerator?.nextObject() != nil {
                guard let name = childFilesEnumerator?.nextObject() as? String else{
                    break
                }
                fileName = name
                let fileAbsolutePath = folderPath.strings(byAppendingPaths: [fileName])
                folderSize += fileSize(filePath: fileAbsolutePath[0])
            }
            return (CGFloat(folderSize) / (1024.0 * 1024.0))
        }
        return 0
    }
    /// 清除缓存
   public func clearCache() {
        let cachPath = NSMutableString.init(string: mfResourceRootPath)
        let files = FileManager.default.subpaths(atPath: cachPath as String)
        for p in files! {
            let path = cachPath.appendingPathComponent(p)
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }
    
    ///计算单个文件的大小
    private func fileSize(filePath: String) -> UInt64 {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            do {
                let attr = try manager.attributesOfItem(atPath: filePath)
                let size = attr[FileAttributeKey.size] as! UInt64
                return size
            } catch  {
                print("error :\(error)")
                return 0
            }
        }
        return 0
    }
    
    
}
