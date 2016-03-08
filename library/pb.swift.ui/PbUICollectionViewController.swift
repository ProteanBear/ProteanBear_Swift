//
//  PbUICollectionViewController.swift
//  pb.swift.ui
//  实现UIViewController中的扩展协议，创建网格视图父类，增加数据绑定载入方法
//  Created by Maqiang on 15/7/5.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

public class PbUICollectionViewController:UICollectionViewController,PbUICollectionViewControllerProtocol,PbUIRefreshConfigProtocol
{
    //loadCellIdentifier
    let loadCellIdentifier="PbUICollectionViewLoadCell"
    
    //collectionData:记录当前的网格使用数据
    public var collectionData:NSMutableArray?
    //dataAdapter:当前使用的数据适配器
    public var dataAdapter:PbDataAdapter?
    //loadCollectionCell:底部载入单元格
    public var loadCollectionCell:PbUICollectionViewCellForLoad?
    //photoData:记录表格对应的列表
    public var photoData=[NSIndexPath:PbDataPhotoRecord]()
    //photoManager:图片载入管理器对象
    public lazy var photoManager=PbDataPhotoManager(downloadMaxCount:1)
    
    /*-----------------------开始：公共方法*/
    
    //pbLoadData:获取数据
    public func pbLoadData(updateMode:PbDataUpdateMode)
    {
        if(self.dataAdapter == nil){self.dataAdapter=PbDataAdapter(delegate: self)}
        self.dataAdapter?.loadData(updateMode)
    }
    
    //pbPhotoKeyInIndexPath:返回单元格中的网络图片标识（不设置则无网络图片下载任务）
    public func pbPhotoKeyInIndexPath(indexPath:NSIndexPath) -> String?
    {
        return nil
    }
    
    //pbPhotoUrlInIndexPath:返回单元格中的网络图片链接（不设置则无网络图片下载任务）
    public func pbPhotoUrlInIndexPath(indexPath:NSIndexPath, data: AnyObject?) -> String?
    {
        return nil
    }
    
    //pbSetQueueForDisplayRow:设置下载图片的序列，只下载显示区域内的图片
    public func pbSetQueueForDisplayRow()
    {
        if let pathArray = self.collectionView?.indexPathsForVisibleItems()
        {
            //创建一个包含所有等待任务的集合
            let allPendingOperations = NSMutableSet(array:Array(self.photoManager.downloadsInProgress.keys))
            
            //构建一个需要撤销的任务的集合，从所有任务中除掉可见行的index path
            let toBeCancelled=allPendingOperations.mutableCopy() as! NSMutableSet
            let visiblePaths=NSSet(array: pathArray)
            toBeCancelled.minusSet(visiblePaths as Set<NSObject>)
            
            //创建一个需要执行的任务的集合,从所有可见index path的集合中除去那些已经在等待队列中的
            let toBeStarted=visiblePaths.mutableCopy() as! NSMutableSet
            toBeStarted.minusSet(allPendingOperations as Set<NSObject>)
            
            //遍历需要撤销的任务，撤消它们
            for indexPath in toBeCancelled
            {
                self.photoManager.downloadCancel(indexPath as! NSIndexPath)
            }
            
            //遍历需要开始的任务
            for indexPath in toBeStarted
            {
                let indexPath=indexPath as! NSIndexPath
                if(self.pbIsLoadCellForDataLoad(indexPath)){continue}
                
                //获取单元对应数据
                var data=self.pbResolveDataInIndexPath(indexPath)
                if(data == nil)
                {
                    data=(self.collectionData?.objectAtIndex(indexPath.row)) as? NSDictionary
                }
                self.pbAddPhotoTaskToQueue(indexPath,data: data)
            }
        }
    }
    
    //pbAddPhotoTaskToQueue:添加图片下载任务到队列
    public func pbAddPhotoTaskToQueue(indexPath:NSIndexPath,data:AnyObject?)
    {
        if let record=self.photoData[indexPath]
        {
            switch(record.state)
            {
            case .New:
                self.photoManager.download(record, callback: { (photoRecord) -> Void in
                    
                    self.collectionView?.reloadItemsAtIndexPaths([indexPath])
                    
                    },imageFilter:{ (image:UIImage)->UIImage? in
                        
                        return self.pbImageFilterForCell(image, indexPath: indexPath, data: data)
                })
            default:
                _=0
            }
        }
    }
    
    //pbGetPhotoImageSize:获取指定位置的图片尺寸
    public func pbGetPhotoImageSize(indexPath:NSIndexPath,data:AnyObject?) -> CGSize?
    {
        return nil
    }
    
    //pbImageFilterForCell:设置图片载入滤镜处理
    public func pbImageFilterForCell(image:UIImage,indexPath:NSIndexPath,data:AnyObject?) -> UIImage?
    {
        if let size=self.pbGetPhotoImageSize(indexPath, data: data)
        {
            //滤镜处理：缩放图片
            let isLand=(image.size.width>image.size.height)
            let scale=isLand ? (size.height/image.size.height):(size.width/image.size.width)
            return UIImage.scaleImage(image,toScale:scale)
        }
        return nil
    }
    
    //pbFullUrlForDataLoad:根据给定的路径获取全路径
    public func pbFullUrlForDataLoad(url:String?) -> String?
    {
        var result=url
        
        if(result != nil)
        {
            if(result!.hasPrefix("http:"))
            {
                
            }
            else
            {
                result=PbDataAppController.getInstance.server+result!
            }
        }
        
        return result
    }
    
    //pbIsLoadCellForDataLoad:是否是显示载入单元格
    public func pbIsLoadCellForDataLoad(indexPath:NSIndexPath) -> Bool
    {
        return self.pbSupportFooterLoad() && indexPath.row == self.collectionData?.count
    }
    
    /*-----------------------结束：公共方法*/
    
    /*-----------------------开始：实现PbUICollectionViewControllerProtocol*/
    
    //pbDoInitForDataLoad:数据适配器初始化时调用
    public func pbDoInitForDataLoad(delegate:PbUIViewControllerProtocol?)
    {
        //增加顶部刷新视图
        if(self.pbSupportHeaderRefresh())
        {
            self.collectionView?.pbAddUIRefreshViewToHeader({ () -> Void in
                self.pbLoadData(PbDataUpdateMode.Update)
            },delegate:self)
        }
        //增加底部刷新视图
        if(self.pbSupportFooterLoad())
        {
            //            switch(self.pbSupportHeaderRefreshType())
            //            {
            //                case .auto:
            //
            //                    break
            //
            //                case .pull:
            //                
            //                    break
            //                
            //                default:
            //                    break
            //            }
        }
    }
    
    //pbKeyForDataLoad:返回当前数据访问使用的链接标识
    public func pbKeyForDataLoad() -> String?
    {
        return nil
    }
    
    //pbParamsForDataLoad:返回当前数据访问使用的参数
    public func pbParamsForDataLoad(updateMode:PbDataUpdateMode) -> NSMutableDictionary?
    {
        return NSMutableDictionary()
    }
    
    //pbPageKeyForDataLoad:返回当前数据访问使用的页码参数名称
    public func pbPageKeyForDataLoad() -> String
    {
        return "page"
    }
    
    //pbPropertyForDataLoad:设置数据请求回执附带属性
    //请求返回时附带页码参数
    public func pbPropertyForDataLoad(updateMode:PbDataUpdateMode) -> NSDictionary?
    {
        return nil
    }
    
    //pbWillRequestForDataLoad:开始请求前处理
    public func pbWillRequestForDataLoad(updateMode:PbDataUpdateMode)
    {
        if(self.pbSupportHeaderRefresh())
        {
            self.collectionView?.pbUIRefreshHeaderSetUpdateTime(NSDate())
        }
    }
    
    //pbErrorForDataLoad:出现访问错误时调用
    public func pbErrorForDataLoad(type:PbUIViewControllerErrorType,error:String)
    {
    }
    
    //pbResolveFromResponse:解析处理返回的数据
    public func pbResolveFromResponse(response:NSDictionary) -> AnyObject?
    {
        return nil
    }
    
    //pbDoUpdateForDataLoad:执行更新类相关返回后的处理
    public func pbDoUpdateForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        if(response == nil){return}
        
        //新数据对比，数据相同则不做处理
        let newData=response as! NSArray
        if(self.collectionData != (response as! NSArray))
        {
            //记录数据
            self.collectionData=NSMutableArray(array:newData)
            
            //刷新表格数据
            self.collectionView?.reloadData()
        }
        
        if((updateMode == PbDataUpdateMode.Update) || (updateMode == PbDataUpdateMode.First && !self.pbAutoUpdateAfterFirstLoad()))
        {
            //设置非初次载入
            self.dataAdapter?.isInitLoad=false
        }
    }
    
    //pbDoInsertForDataLoad:执行增量类相关返回后的处理
    public func pbDoInsertForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        let newData=response as? NSArray
        if(self.collectionData == nil){self.collectionData=NSMutableArray()}
        
        if((newData != nil) && (newData!.count > 0))
        {
            //增加表格数据
            self.collectionData?.addObjectsFromArray(newData as! [AnyObject])
            
            //设置表格动态增加索引
            let insertPaths=NSMutableArray(capacity:newData!.count)
            //获取增量对应的节点
            let targetSection=self.pbSectionForInsertData()
            
            //设置增量数据配置数组
            for (var i=0; i<newData!.count; i++)
            {
                let newPath=NSIndexPath(forRow:(self.collectionData?.indexOfObject(newData!.objectAtIndex(i)))!, inSection: targetSection)
                insertPaths.addObject(newPath)
            }
            
            //增量增加表格数据
            self.collectionView?.insertItemsAtIndexPaths((insertPaths as [AnyObject]) as! [NSIndexPath])
        }
        else
        {
            //记录下页无数据状态
            self.dataAdapter?.nextIsNull=true
            
            if(self.pbSupportFooterLoad())
            {
                self.collectionView?.deleteItemsAtIndexPaths([self.collectionView!.indexPathForCell(self.loadCollectionCell!)!])
            }
        }
    }
    
    //pbDoUIDisplayForDataLoad:执行相关返回后的视图更新处理
    public func pbDoUIDisplayForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbDoEndForDataLoad:执行数据载入结束后的处理
    public func pbDoEndForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        //结束顶部视图载入状态
        if(self.pbSupportHeaderRefresh() && (updateMode==PbDataUpdateMode.Update))
        {
            self.collectionView?.pbUIRefreshHeaderEnd()
        }
        
        //结束底部载入指示器
        if(self.pbSupportFooterLoad() && (updateMode==PbDataUpdateMode.NextPage))
        {
            self.loadCollectionCell?.stopLoadAnimating()
        }
    }
    
    //pbAutoUpdateAfterFirstLoad:初次载入后是否立即更新
    public func pbAutoUpdateAfterFirstLoad() -> Bool
    {
        return true
    }
    
    //pbSectionForInsertData:放回插入数据时对应的分组值
    func pbSectionForInsertData() -> Int
    {
        return 0
    }
    
    //pbSupportActivityIndicator:是否支持载入显示器
    public func pbSupportActivityIndicator() -> PbUIActivityIndicator?
    {
        let indicator=PbUIRingSpinnerCoverView(frame:CGRectMake(0, 0, 2000, 2000))
        indicator.center=self.view.center
        indicator.tintColor=self.pbUIRefreshActivityDefaultColor()
        indicator.backgroundColor=UIColor.whiteColor()
        indicator.stopAnimating()
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        
        self.view.layoutIfNeeded()
        
        return indicator
    }
    
    //pbSupportHeaderRefresh:是否支持表格顶部刷新
    public func pbSupportHeaderRefresh() -> Bool
    {
        return true
    }
    
    //pbSupportHeaderRefreshColor:表格顶部刷新的颜色
    public func pbSupportHeaderRefreshColor() -> UIColor?
    {
        return nil
    }
    
    //pbSupportFooterLoad:是否支持表格底部载入
    public func pbSupportFooterLoad() -> Bool
    {
        return true
    }
    
    //pbSupportFooterLoadType:返回表格底部载入类型
    public func pbSupportFooterLoadType() -> PbUIViewType
    {
        return PbUIViewType.auto
    }
    
    //pbSupportFooterLoadColor:表格底部载入主题颜色（tiniColor）
    public func pbSupportFooterLoadColor() -> UIColor?
    {
        return nil
    }
    
    //pbResolveDataInIndexPath:获取指定单元格位置的数据
    public func pbResolveDataInIndexPath(indexPath:NSIndexPath) -> AnyObject?
    {
        return nil
    }
    
    //pbIdentifierForCollectionView:返回指定位置的单元格标识
    public func pbIdentifierForCollectionView(indexPath:NSIndexPath,data:AnyObject?) -> String
    {
        return "PbUICollectionViewDataCell"
    }
    
    //pbNibNameForCollectionView:返回指定位置单元格使用的资源文件
    public func pbNibNameForCollectionView(indexPath:NSIndexPath,data:AnyObject?) -> String?
    {
        return nil
    }
    
    //pbCellClassForCollectionView:返回指定位置单元格的类
    public func pbCellClassForCollectionView(indexPath:NSIndexPath,data:AnyObject?) -> AnyClass?
    {
        return nil
    }
    
    //pbSetDataForCollectionView:设置表格数据显示
    public func pbSetDataForCollectionView(cell:AnyObject,data:AnyObject?,photoRecord:PbDataPhotoRecord?,indexPath:NSIndexPath) -> AnyObject
    {
        return cell
    }
    
    /*-----------------------结束：实现PbUICollectionViewControllerProtocol*/
    
    /*-----------------------开始：实现UICollectionViewDataSource*/
    
    //collectionView:numberOfItemsInSection:返回每节网格内的网格数
    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var result=0
        
        if(self.collectionData != nil)
        {
            result=self.collectionData!.count
            result=((self.pbSupportFooterLoad())
                && self.dataAdapter != nil
                && (!self.dataAdapter!.nextIsNull))
                    ?(result+1)
                    :result
        }
        
        return result
    }
    
    //collectionView:cellForItemAtIndexPath:返回每节每个网格的单元样式
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var result:UICollectionViewCell?
        
        if(self.collectionData != nil)
        {
            //使用底部载入单元格
            if(self.pbSupportFooterLoad()&&indexPath.row==self.collectionData?.count)
            {
                self.collectionView?.registerClass(PbUICollectionViewCellForLoad.self, forCellWithReuseIdentifier:loadCellIdentifier)
                result=self.collectionView?.dequeueReusableCellWithReuseIdentifier(loadCellIdentifier, forIndexPath: indexPath)
                
                self.loadCollectionCell=result as? PbUICollectionViewCellForLoad
                if let color = self.pbSupportFooterLoadColor()
                {
                    self.loadCollectionCell?.setIndicatorTiniColor(color)
                }
//                self.loadCollectionCell?.startLoadAnimating()
                return result!
            }
            
            //获取单元对应数据
            var data=self.pbResolveDataInIndexPath(indexPath)
            if(data == nil)
            {
                data=self.collectionData?.objectAtIndex(indexPath.row)
            }
            
            //获取并记录单元数据中的网络图片
            var imageRecord:PbDataPhotoRecord?=self.photoData[indexPath]
            if(imageRecord == nil)
            {
                if let photoKey = self.pbPhotoKeyInIndexPath(indexPath)
                {
                    if let photoUrl: AnyObject = data!.objectForKey(photoKey)
                    {
                        imageRecord=PbDataPhotoRecord(urlString:self.pbFullUrlForDataLoad(photoUrl as? String)!, index: indexPath)
                        self.photoData[indexPath]=imageRecord
                    }
                }
                if let photoUrl = self.pbPhotoUrlInIndexPath(indexPath,data:data)
                {
                    imageRecord=PbDataPhotoRecord(urlString:self.pbFullUrlForDataLoad(photoUrl)!, index: indexPath)
                    self.photoData[indexPath]=imageRecord
                }
            }
            
            //注册资源文件
            if let nibName=self.pbNibNameForCollectionView(indexPath, data: data)
            {
                self.collectionView!.registerNib(UINib(nibName:nibName, bundle:NSBundle.mainBundle()), forCellWithReuseIdentifier: self.pbIdentifierForCollectionView(indexPath, data: data))
            }
            if let cellClass: AnyClass=self.pbCellClassForCollectionView(indexPath, data: data)
            {
                self.collectionView?.registerClass(cellClass, forCellWithReuseIdentifier:self.pbIdentifierForCollectionView(indexPath, data: data))
            }
            
            //获取未使用的单元对象
            let identifier=self.pbIdentifierForCollectionView(indexPath, data: data)
            result=(self.collectionView?.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath))
            
            //创建表格单元对象
            if(result == nil)
            {
                result=UICollectionViewCell()
            }
            
            //设置数据
            result=(self.pbSetDataForCollectionView(result!,data: data,photoRecord:imageRecord,indexPath: indexPath)) as? UICollectionViewCell
            
            //关闭指示器
            if(indexPath.row==1&&indexPath.section==0)
            {
                self.dataAdapter?.indicator?.stopAnimating()
            }
        }
        else
        {
            result=UICollectionViewCell()
        }
        
        return result!
    }
    
    /*-----------------------结束：实现UICollectionViewDataSource*/
    
    /*-----------------------开始：实现UIScrollViewDelegate*/
    
    //scrollViewWillBeginDragging:滚动视图开始拖动
    override public func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        //挂起全部图片载入任务
        self.photoManager.downloadPauseAll()
    }
    
    //scrollViewDidEndDragging:滚动视图结束拖动
    override public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        //只载入显示区域内的图片
        self.pbSetQueueForDisplayRow()
        //继续载入任务
        self.photoManager.downloadResumeAll()
    }
    
    //scrollViewDidEndDecelerating:滚动视图结束减速
    override public func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        //只载入显示区域内的图片
//        self.pbSetQueueForDisplayRow()
        //继续载入任务
//        self.photoManager.downloadResumeAll()
        
        //到达尾部时载入下页
        if(self.pbSupportFooterLoad())
        {
            if let pathArray = self.collectionView?.indexPathsForVisibleItems()
            {
                for indexPath in pathArray
                {
                    let indexPath:NSIndexPath=indexPath 
                    if(indexPath == NSIndexPath(forRow:self.collectionData!.count, inSection:indexPath.section)&&(!self.dataAdapter!.nextIsNull)&&(!self.dataAdapter!.isInitLoad)&&(!self.dataAdapter!.isDataLoading))
                    {
                        //显示翻页载入指示器
                        self.loadCollectionCell?.startLoadAnimating()
                        
                        //载入下页数据
                        self.pbLoadData(PbDataUpdateMode.NextPage)
                    }
                }
            }
        }
    }
    
    /*-----------------------结束：实现UIScrollViewDelegate*/
    
    /*-----------------------开始：实现PbUIRefreshConfigProtocol*/
    
    public func pbUIRefreshViewBackgroudColor() -> UIColor{return UIColor.clearColor()}
    public func pbUIRefreshLabelFontSize() -> CGFloat{return 12}
    public func pbUIRefreshLabelTextColor() -> UIColor{return UIColor.darkGrayColor()}
    public func pbUIRefreshActivityView() -> PbUIActivityIndicator?{return nil}
    public func pbUIRefreshActivityDefaultSize() -> CGSize{return CGSizeMake(32,32)}
    public func pbUIRefreshActivityDefaultColor() -> UIColor{return UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1)}
    
    /*-----------------------结束：实现PbUIRefreshConfigProtocol*/
}
