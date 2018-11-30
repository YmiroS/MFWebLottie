//
//  ZipTool.swift
//  MFWebLottie_Tests
//
//  Created by 杨烁 on 2018/11/28.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

let mfResourceRootPath = NSMutableString.init(string: NSHomeDirectory()).appendingPathComponent("Documents/MFWebLottieResource")
let mfUnZipPath = mfResourceRootPath +  "/LottieUnzipResource"
let mfDownloadFilePath = mfResourceRootPath +  "/LottieDownloadResource"

@objc protocol MFZipToolDelegate {
    @objc optional func unZipWillStart()
    @objc optional func unZipSuccess(fileName:String)
    @objc optional func unZipFailed()
    @objc optional func unZipProgress(loaded:Int,total:Int)
    @objc optional func haveExisted()
}

class MFZipManager: NSObject, SSZipArchiveDelegate {
    
    var unZipFileStatus: Bool?
    
    var unZipFileName: String?
    
    weak var delegate:MFZipToolDelegate?
    
    override init() {
        super.init()
        RunloopTools.sharedInstance()?.loadRunLoop()
    }
    
    /// 解压文件
    /// json的文件名要与文件夹名字一致
    /// - Parameter zipFileName: 解压文件名
    public func unZipFile(zipFileName:String){
        self.unZipFileName = zipFileName
        ///压缩文件路径
        let zipFilePath = mfDownloadFilePath + "/\(zipFileName).zip"
        ///解压缩目录
        let toZipPath = mfUnZipPath + "/\(zipFileName)/"
        RunloopTools.sharedInstance()?.addTask({ () -> Bool in
            SSZipArchive.unzipFile(atPath: zipFilePath, toDestination: toZipPath, delegate: self)
        }, withKey: zipFileName)
    }
    
    
    /// 失败删除文件
    ///
    /// - Parameter path: 原始Zip文件路径
    fileprivate func failedDeleteFile(path:String){
        do{
            try FileManager.default.removeItem(atPath: path)
        }
        catch{
            print(error)
        }
    }
}

extension MFZipManager {
    
    ///进度
    func zipArchiveProgressEvent(_ loaded: Int, total: Int) {
        DispatchQueue.main.async {
            self.delegate?.unZipProgress?(loaded: loaded, total: total)
            print(NSString.init(format: "解压进度--%.2f%", (CGFloat(loaded)/CGFloat(total) * 100)))
        }
    }
    ///即将解压
    func zipArchiveWillUnzipArchive(atPath path: String!, zipInfo: unz_global_info) {
        self.delegate?.unZipWillStart?()
    }
    //解压完成
    func zipArchiveDidUnzipArchive(atPath path: String!, zipInfo: unz_global_info, unzippedPath: String!) {
        DispatchQueue.main.async {[weak self] in
            self?.delegate?.unZipSuccess?(fileName: self?.unZipFileName ?? "")
            self?.deleteOriginalFile(path: path)
        }
    }
    
    func zipArchiveDidUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String!, fileInfo: unz_file_info) {
        
    }
    func zipArchiveWillUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String!, fileInfo: unz_file_info) {
    }
    
    //解压成功后删除源文件
    func deleteOriginalFile(path: String){
        do{
            try FileManager.default.removeItem(atPath: path)
        }
        catch{
            print(error)
        }
    }
    
    
}
