//
//  ZipTool.swift
//  MFWebLottie_Tests
//
//  Created by 杨烁 on 2018/11/28.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@objc protocol ZipToolDelegate {
    @objc optional func unZipWillStart()
    @objc optional func unZipSuccess()
    @objc optional func unZipFailed()
    @objc optional func unZipProgress(loaded:Int,total:Int)
    @objc optional func haveExisted()
}

class ZipTool: NSObject, SSZipArchiveDelegate {
    
    var unZipFileStatus:Bool?

    weak var delegate:ZipToolDelegate?
    
    let unZipPath = ((FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]).appendingPathComponent("LottieUnzipResource/)")).absoluteString

    let downloadFilePath = ((FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]).appendingPathComponent("LottieDownloadResource/)")).absoluteString

    /// 解压文件
    ///
    /// - Parameters:
    ///   - UnZipPath: 需要解压文件的路径
    ///   - toPath: 加压目的路径
    public func unZipFile(needZipFileName:String){
        ///压缩文件路径
        let zipFilePath = self.downloadFilePath + "\(needZipFileName).zip"
        ///解压缩目录
        let unZipPath = self.unZipPath + "\(needZipFileName)/"
        RunloopTools.sharedInstance()?.addTask({ () -> Bool in
            SSZipArchive.unzipFile(atPath: zipFilePath, toDestination: unZipPath, delegate: self)
        }, withKey: needZipFileName)
    }
    
}

extension ZipTool {
    
    ///进度
    private func zipArchiveProgressEvent(_ loaded: Int, total: Int) {
        self.delegate?.unZipProgress?(loaded: loaded, total: total)
    }
    ///即将解压
    private func zipArchiveWillUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String!, fileInfo: unz_file_info) {
        self.delegate?.unZipWillStart?()
    }
    ///解压完成
    private func zipArchiveDidUnzipFile(at fileIndex: Int, totalFiles: Int, archivePath: String!, fileInfo: unz_file_info) {
        if fileIndex == totalFiles{
            self.delegate?.unZipSuccess?()
        }else{
            self.delegate?.unZipFailed?()
        }
        
    }
    
    
}
