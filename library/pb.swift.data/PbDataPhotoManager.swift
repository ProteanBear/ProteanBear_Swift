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
public enum PbDataPhotoState
{
    case new, downloaded, filtered, failed
}

//PbDataPhotoRecord:记录当前图片处理的相关信息
open class PbDataPhotoRecord
{
    open let url:String
    open var state = PbDataPhotoState.new
    open var image = UIImage(named: "default_placeholder")
    open var indexPath=IndexPath(index: 1)
    
    public init(urlString:String,index:IndexPath)
    {
        self.url = urlString
        self.indexPath=index
    }
}

//PbDataPhotoDownloadOperate:图片数据下载器
open class PbDataPhotoDownloadOperate:Operation
{
    let photoRecord:PbDataPhotoRecord
    
    public init(photoRecord:PbDataPhotoRecord)
    {
        self.photoRecord=photoRecord
    }
    
    override open func main()
    {
        if(self.isCancelled){return}
        
        //从缓存中读取
        if let cacheImage = PbDataAppController.getInstance.imageInLocalCache(photoRecord.url)
        {
            //更新下载记录状态
            self.photoRecord.image=cacheImage
            self.photoRecord.state=PbDataPhotoState.downloaded
        }
        else
        {
            let data:Data?=try? Data(contentsOf: URL(string: photoRecord.url)!)
            
            if(data != nil && data!.count>0)
            {
                //更新下载记录状态
                self.photoRecord.image=UIImage(data: data!)
                self.photoRecord.state=PbDataPhotoState.downloaded
                
                PbLog.debug("PbDataPhotoDownloadOperate:main:下载图片("+self.photoRecord.url+")完成")
                //记录图片到缓存
                PbDataAppController.getInstance.saveImageIntoLocalCache(data!,forUrl:self.photoRecord.url)
            }
            else
            {
                //更新下载记录状态
                self.photoRecord.image=UIImage(named:"default_failed")
                self.photoRecord.state=PbDataPhotoState.failed
            }
        }
    }
}

//PbDataPhotoFilterOperate:图片使用滤镜加载器
open class PbDataPhotoFilterOperate:Operation
{
    let photoRecord:PbDataPhotoRecord
    //自定义图片处理
    var specialFilter:((_ image:UIImage)->UIImage?)?
    
    public init(photoRecord:PbDataPhotoRecord,specialFilter:((_ image:UIImage)->UIImage?)?)
    {
        self.photoRecord=photoRecord
        self.specialFilter=specialFilter
    }
    
    override open func main()
    {
        if(self.isCancelled){return}
        if(self.photoRecord.state != PbDataPhotoState.downloaded){return}
        
        if let filteredImage = self.applySepiaFilter(self.photoRecord.image!)
        {
            self.photoRecord.image = filteredImage
            self.photoRecord.state = PbDataPhotoState.filtered
        }
    }
    
    open func applySepiaFilter(_ image:UIImage) -> UIImage?
    {
        if(self.specialFilter != nil)
        {
            return self.specialFilter!(image)
        }
        return nil
    }
}

//PbDataPhotoManager:图片下载队列管理器
open class PbDataPhotoManager
{
    //downloadsInProgress:跟踪当前正在进行的下载进程
    lazy var downloadsInProgress=[IndexPath:Operation]()
    //downloadQueue:下载队列
    lazy var downloadQueue=OperationQueue()
    //downloadMaxCount:下载线程最大并发量
    lazy var downloadMaxCount=0
    
    //filterInProgress:跟踪当前正在进行的滤镜进程
    lazy var filterInProgress=[IndexPath:Operation]()
    //filterQueue:滤镜队列
    lazy var filterQueue=OperationQueue()
    //filterMaxCount:滤镜线程最大并发量
    lazy var filterMaxCount=0
    
    public init()
    {
        self.downloadQueue.name="PbDataPhotoManager:Download"
        self.filterQueue.name="PbDataPhotoManager:Filter"
    }
    
    public convenience init(downloadMaxCount:Int)
    {
        self.init()
        
        if(downloadMaxCount>0){self.downloadQueue.maxConcurrentOperationCount=downloadMaxCount}
    }
    
    public convenience init(filterMaxCount:Int)
    {
        self.init()
        
        if(filterMaxCount>0){self.filterQueue.maxConcurrentOperationCount=filterMaxCount}
    }
    
    public convenience init(downloadMaxCount:Int,filterMaxCount:Int)
    {
        self.init()
        
        if(downloadMaxCount>0){self.downloadQueue.maxConcurrentOperationCount=downloadMaxCount}
        if(filterMaxCount>0){self.filterQueue.maxConcurrentOperationCount=filterMaxCount}
    }
    
    //download:下载给定的图片数组
    open func download(_ photos:Array<PbDataPhotoRecord>,callback:@escaping (_ photoRecord:PbDataPhotoRecord) -> Void)
    {
        self.download(photos, callback: callback, imageFilter: nil)
    }
    
    //download:下载给定的图片
    open func download(_ photo:PbDataPhotoRecord,callback:@escaping (_ photoRecord:PbDataPhotoRecord) -> Void)
    {
        self.download(photo, callback: callback, imageFilter: nil)
    }
    
    //download:下载给定的图片数组
    open func download(_ photos:Array<PbDataPhotoRecord>,callback:@escaping (_ photoRecord:PbDataPhotoRecord) -> Void,imageFilter:((_ image:UIImage)->UIImage?)?)
    {
        for photo:PbDataPhotoRecord in photos
        {
            self.download(photo,callback:callback,imageFilter:imageFilter)
        }
    }
    
    //download:下载给定的图片
    open func download(_ photo:PbDataPhotoRecord,callback:@escaping (_ photoRecord:PbDataPhotoRecord) -> Void,imageFilter:((_ image:UIImage)->UIImage?)?)
    {
        //已在进行的进程
        if let _ = downloadsInProgress[photo.indexPath]{return}
        
        //创建任务
        let downloadOperate=PbDataPhotoDownloadOperate(photoRecord:photo)
        downloadOperate.completionBlock={
            
            if(downloadOperate.isCancelled){return}
            
            if(imageFilter != nil)
            {
                //增加滤镜任务
                let filterOperate=PbDataPhotoFilterOperate(photoRecord:photo,specialFilter:imageFilter)
                filterOperate.completionBlock={
                    if(filterOperate.isCancelled){return}
                    
                    //移除下载任务
                    let operate=downloadOperate as PbDataPhotoDownloadOperate
                    self.downloadsInProgress.removeValue(forKey: operate.photoRecord.indexPath)
                    
                    //移除滤镜任务
                    self.filterInProgress.removeValue(forKey: operate.photoRecord.indexPath)
                    
                    DispatchQueue.main.async(execute: {
                        callback(operate.photoRecord)
                    })
                }
                
                //添加任务到队列中
                self.filterInProgress[photo.indexPath]=filterOperate
                self.filterQueue.addOperation(filterOperate)
            }
            else
            {
                //移除下载任务
                let operate=downloadOperate as PbDataPhotoDownloadOperate
                self.downloadsInProgress.removeValue(forKey: operate.photoRecord.indexPath)
                
                DispatchQueue.main.async(execute: {
                    callback(operate.photoRecord)
                })
            }
        }
        
        //添加任务到队列中
        self.downloadsInProgress[photo.indexPath]=downloadOperate
        self.downloadQueue.addOperation(downloadOperate)
    }
    
    //downloadCancel:取消全部图片下载任务
    open func downloadCancel()
    {
        for indexPath:IndexPath in downloadsInProgress.keys
        {
            let operation=downloadsInProgress[indexPath]
            operation?.cancel()
        }
        downloadsInProgress.removeAll(keepingCapacity:false)
    }
    
    //downloadCancel:取消指定的图片下载任务
    open func downloadCancel(_ indexPath:IndexPath)
    {
        let operation=downloadsInProgress[indexPath]
        operation?.cancel()
        downloadsInProgress.removeValue(forKey: indexPath)
    }
    
    //downloadCancel:取消指定的图片下载任务
    open func downloadCancel(_ photo:PbDataPhotoRecord)
    {
        self.downloadCancel(photo.indexPath)
    }
    
    //downloadCancel:取消指定的图片下载任务
    open func downloadCancel(_ urlString:String)
    {
        for indexPath:IndexPath in downloadsInProgress.keys
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
    open func downloadPauseAll()
    {
        self.downloadQueue.isSuspended=true
    }
    
    //downloadResumeAll:继续全部下载任务
    open func downloadResumeAll()
    {
        self.downloadQueue.isSuspended=false
    }
    
    //downloadCancel:清除全部
    open func downloadCancelAll()
    {
        for indexPath:IndexPath in downloadsInProgress.keys
        {
            let operation=downloadsInProgress[indexPath]
            operation?.cancel()
        }
        downloadsInProgress.removeAll()
    }
    
    //filterCancel:取消全部图片下载任务
    open func filterCancel()
    {
        for indexPath:IndexPath in filterInProgress.keys
        {
            let operation=filterInProgress[indexPath]
            operation?.cancel()
        }
        filterInProgress.removeAll(keepingCapacity:false)
    }
    
    //filterCancel:取消指定的图片下载任务
    open func filterCancel(_ indexPath:IndexPath)
    {
        let operation=filterInProgress[indexPath]
        operation?.cancel()
        filterInProgress.removeValue(forKey: indexPath)
    }
    
    //filterCancel:取消指定的图片滤镜任务
    open func filterCancel(_ photo:PbDataPhotoRecord)
    {
        self.filterCancel(photo.indexPath)
    }
    
    //filterCancel:取消指定的图片滤镜任务
    open func filterCancel(_ urlString:String)
    {
        for indexPath:IndexPath in filterInProgress.keys
        {
            let operation=filterInProgress[indexPath]
            if(urlString == (operation as! PbDataPhotoFilterOperate).photoRecord.url)
            {
                self.filterCancel(indexPath)
                break
            }
        }
    }
    
    //filterPauseAll:暂停全部滤镜任务
    open func filterPauseAll()
    {
        self.filterQueue.isSuspended=true
    }
    
    //filterResumeAll:继续全部滤镜任务
    open func filterResumeAll()
    {
        self.filterQueue.isSuspended=false
    }
}
