//
//  MFDownloadManager.swift
//  MFWebLottie
//
//  Created by 杨烁 on 2018/11/29.
//  Copyright © 2018 杨烁. All rights reserved.
//

import UIKit

class MFDownloadManager: NSObject, URLSessionDownloadDelegate {
    
    static let shared:MFDownloadManager = {
        let instance = MFDownloadManager()
        instance.session = URLSession.init(configuration: .default, delegate: instance, delegateQueue: OperationQueue.main)
        return instance
    }()
    
    fileprivate var basePath:String = ""
    fileprivate var session:URLSession?
    fileprivate var downloadProgressCallBack:((Int64, Int64) -> Void)?
    fileprivate var downloadFinishCallBack:(() -> Void)?
    fileprivate var failedCallBack:((String) -> Void)?
    
    
    /// 设定基地址
    ///
    /// - Parameter basePath: 基地址
    public func setBasePath(_ basePath:String){
        self.basePath = basePath
    }
    
    
    
    /// 检测资源MD5
    ///
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - checkResourceMD5: 检测资源的MD5值
    public func checkResourceIsUpdate(fileName:String,
                                      checkResourceMD5:@escaping ((String) -> Void)){
        guard let url = URL.init(string: basePath + "/\(fileName).zip") else {
            print("下载地址不规范")
            return
        }
        var request = URLRequest.init(url: url)
        request.httpMethod = "HEAD"
        session?.dataTask(with: request, completionHandler:
            { (data, urlResponse, error) in
                guard let dic = (urlResponse as? HTTPURLResponse)?.allHeaderFields as?[String:Any],
                    let md5 = dic["Content-MD5"] as? String else{
                        return
                }
                checkResourceMD5(md5)
        }).resume()
    }
    
    /// 下载资源
    ///
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - downloadProgressCallBack: 下载资源进度
    ///   - downloadFinishCallBack: 下载完成回调
    ///   - failedCallBack: 下载失败回调("原因")
    public func downloadResource(fileName:String,
                                 downloadProgressCallBack:((Int64, Int64) -> Void)? = nil,
                                 downloadFinishCallBack:(() -> Void)? = nil,
                                 failedCallBack:((String) -> Void)? = nil){
        self.downloadProgressCallBack = downloadProgressCallBack
        self.downloadFinishCallBack = downloadFinishCallBack
        self.failedCallBack = failedCallBack
        guard let url = URL.init(string: basePath + "/\(fileName).zip") else {
            self.failedCallBack?("下载地址不规范")
            return
        }
        let downTask = session?.downloadTask(with: url)
        downTask?.resume()
    }
    
    
}

extension MFDownloadManager{
    ///下载结果
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //拼接一个存放的路径   suggestedFilename是该文件在服务器里面的文件名，建议客户端和的文件名跟服务器的一样
        guard let fileName = downloadTask.response?.suggestedFilename else{
            failedCallBack?("下载失败")
            return
        }
        let filePath = mfDownloadFilePath + "/\(fileName)"
        print(filePath)
        let fileManager = FileManager.default
        do{
            ///判断文件夹是否存在
            let exist = fileManager.fileExists(atPath: mfDownloadFilePath)
            if !exist{
                ///创建文件夹
                try fileManager.createDirectory(atPath: mfDownloadFilePath, withIntermediateDirectories: true, attributes: nil)
            }
            try fileManager.moveItem(atPath: (location.path), toPath: filePath)
            downloadFinishCallBack?()
        }catch{
            failedCallBack?("文件夹移动失败,或者已经存在")
            return
        }
        
    }
    
    ///下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        downloadProgressCallBack?(totalBytesWritten,totalBytesExpectedToWrite)
        
        print("下载进度-----\((Float(totalBytesWritten)) / Float(totalBytesExpectedToWrite))")
        
    }
    
}

