//
//  PbDataPhotoManager.swift
//  pb.swift.data
//  图片下载管理器，支持线程中任务队列方式下载图片
//  Created by Maqiang on 15/6/26.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

//PbDataPhotoState:图片处理状态，包括新图片、已下载、已加滤镜和失败
enum PbDataPhotoState
{
    case New, Downloaded, Filtered, Failed
}

//PbDataPhotoRecord:记录当前图片处理的相关信息
class PbDataPhotoRecord
{
    let url:String
    var state = PbDataPhotoState.New
    var image = UIImage(named: "default_placeholder")
    var indexPath=NSIndexPath(index: 1)
    
    init(urlString:String,index:NSIndexPath)
    {
        self.url = urlString
        self.indexPath=index
    }
}

//PbDataPhotoDownloadOperate:图片数据下载器
class PbDataPhotoDownloadOperate:NSOperation
{
    let photoRecord:PbDataPhotoRecord
    
    init(photoRecord:PbDataPhotoRecord)
    {
        self.photoRecord=photoRecord
    }
    
    override func main()
    {
        if(self.cancelled){return}
        
        //从缓存中读取
        if let cacheImage = PbDataAppController.getInstance.imageInLocalCache(photoRecord.url)
        {
            //更新下载记录状态
            self.photoRecord.image=cacheImage
            self.photoRecord.state=PbDataPhotoState.Downloaded
        }
        else
        {
            let data:NSData?=NSData(contentsOfURL: NSURL(string: photoRecord.url)!)
            
            if(data != nil && data!.length>0)
            {
                //更新下载记录状态
                self.photoRecord.image=UIImage(data: data!)
                self.photoRecord.state=PbDataPhotoState.Downloaded
                
                PbLog.debug("PbDataPhotoDownloadOperate:main:下载图片("+self.photoRecord.url+")完成")
                //记录图片到缓存
                PbDataAppController.getInstance.saveImageIntoLocalCache(data!,forUrl:self.photoRecord.url)
            }
            else
            {
                //更新下载记录状态
                self.photoRecord.image=UIImage(named:"default_failed")
                self.photoRecord.state=PbDataPhotoState.Failed
            }
        }
    }
}

//PbDataPhotoFilterOperate:图片使用滤镜加载器
class PbDataPhotoFilterOperate:NSOperation
{
    let photoRecord:PbDataPhotoRecord
    
    init(photoRecord:PbDataPhotoRecord)
    {
        self.photoRecord=photoRecord
    }
    
    override func main()
    {
        if(self.cancelled){return}
        if(self.photoRecord.state != PbDataPhotoState.Downloaded){return}
        
        if let filteredImage = self.applySepiaFilter(self.photoRecord.image!)
        {
            self.photoRecord.image = filteredImage
            self.photoRecord.state = PbDataPhotoState.Filtered
        }
    }
    
    func applySepiaFilter(image:UIImage) -> UIImage? {return nil}
}

//PbDataPhotoManager:图片下载队列管理器
class PbDataPhotoManager
{
    //downloadsInProgress:跟踪当前正在进行的下载进程
    lazy var downloadsInProgress=[NSIndexPath:NSOperation]()
    //downloadQueue:下载队列
    lazy var downloadQueue=NSOperationQueue()
    //downloadMaxCount:下载线程最大并发量
    lazy var downloadMaxCount=0
    
    //filterInProgress:跟踪当前正在进行的滤镜进程
    lazy var filterInProgress=[NSIndexPath:NSOperation]()
    //filterQueue:滤镜队列
    lazy var filterQueue=NSOperationQueue()
    //filterMaxCount:滤镜线程最大并发量
    lazy var filterMaxCount=0
    
    init()
    {
        self.downloadQueue.name="PbDataPhotoManager:Download"
        self.filterQueue.name="PbDataPhotoManager:Filter"
    }
    
    convenience init(downloadMaxCount:Int)
    {
        self.init()
        
        if(downloadMaxCount>0){self.downloadQueue.maxConcurrentOperationCount=downloadMaxCount}
    }
    
    convenience init(filterMaxCount:Int)
    {
        self.init()
        
        if(filterMaxCount>0){self.filterQueue.maxConcurrentOperationCount=filterMaxCount}
    }
    
    convenience init(downloadMaxCount:Int,filterMaxCount:Int)
    {
        self.init()
        
        if(downloadMaxCount>0){self.downloadQueue.maxConcurrentOperationCount=downloadMaxCount}
        if(filterMaxCount>0){self.filterQueue.maxConcurrentOperationCount=filterMaxCount}
    }
    
    //download:下载给定的图片数组
    func download(photos:Array<PbDataPhotoRecord>,callback:(photoRecord:PbDataPhotoRecord) -> Void)
    {
        for photo:PbDataPhotoRecord in photos
        {
            self.download(photo,callback:callback)
        }
    }
    
    //download:下载给定的图片
    func download(photo:PbDataPhotoRecord,callback:(photoRecord:PbDataPhotoRecord) -> Void)
    {
        //已在进行的进程
        if let _ = downloadsInProgress[photo.indexPath]{return}
        
        //创建任务
        let downloadOperate=PbDataPhotoDownloadOperate(photoRecord:photo)
        downloadOperate.completionBlock={
            
            if(downloadOperate.cancelled){return}
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let operate=downloadOperate as PbDataPhotoDownloadOperate
                
                self.downloadsInProgress.removeValueForKey(operate.photoRecord.indexPath)
                callback(photoRecord: operate.photoRecord)
            })
        }
        
        //添加任务到队列中
        self.downloadsInProgress[photo.indexPath]=downloadOperate
        downloadQueue.addOperation(downloadOperate)
    }
    
    //downloadCancel:取消全部图片下载任务
    func downloadCancel()
    {
        for indexPath:NSIndexPath in downloadsInProgress.keys
        {
            let operation=downloadsInProgress[indexPath]
            operation?.cancel()
        }
        downloadsInProgress.removeAll(keepCapacity:false)
    }
    
    //downloadCancel:取消指定的图片下载任务
    func downloadCancel(indexPath:NSIndexPath)
    {
        let operation=downloadsInProgress[indexPath]
        operation?.cancel()
        downloadsInProgress.removeValueForKey(indexPath)
    }
    
    //downloadCancel:取消指定的图片下载任务
    func downloadCancel(photo:PbDataPhotoRecord)
    {
        self.downloadCancel(photo.indexPath)
    }
    
    //downloadCancel:取消指定的图片下载任务
    func downloadCancel(urlString:String)
    {
        for indexPath:NSIndexPath in downloadsInProgress.keys
        {
            let operation=downloadsInProgress[indexPath]
            if(urlString == (operation as! PbDataPhotoDownloadOperate).photoRecord.url)
            {
                self.downloadCancel(indexPath)
                break
            }
        }
    }
    
    //downloadPauseAll:暂停全部下载任务
    func downloadPauseAll()
    {
        self.downloadQueue.suspended=true
    }
    
    //downloadResumeAll:继续全部下载任务
    func downloadResumeAll()
    {
        self.downloadQueue.suspended=false
    }
}