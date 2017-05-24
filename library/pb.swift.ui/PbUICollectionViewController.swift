//
//  PbUICollectionViewController.swift
//  pb.swift.ui
//  实现UIViewController中的扩展协议，创建网格视图父类，增加数据绑定载入方法
//  Created by Maqiang on 15/7/5.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

/// 实现UIViewController中的扩展协议，创建网格视图父类，增加数据绑定载入方法
open class PbUICollectionViewController:UICollectionViewController,PbUICollectionViewControllerProtocol,PbUIRefreshConfigProtocol
{
    /// loadCellIdentifier
    open let loadCellIdentifier="PbUICollectionViewLoadCell"
    
    /// 记录当前的网格使用数据
    open var collectionData:NSMutableArray?
    /// 当前使用的数据适配器
    open var dataAdapter:PbDataAdapter?
    /// 底部载入单元格
    open var loadCollectionCell:PbUICollectionViewCellForLoad?
    /// 记录表格对应的列表
    open var photoData=[IndexPath:PbDataPhotoRecord]()
    /// 图片载入管理器对象
    open lazy var photoManager=PbDataPhotoManager(downloadMaxCount:1)
    
    /*-----------------------开始：公共方法*/
    
    /// 获取数据
    /// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
    open func pbLoadData(_ updateMode:PbDataUpdateMode)
    {
        if(self.dataAdapter == nil){self.dataAdapter=PbDataAdapter(delegate: self)}
        self.dataAdapter?.loadData(updateMode)
    }
    
    /// 返回单元格中的网络图片标识（不设置则无网络图片下载任务）
    /// - parameter indexPath:单元格位置索引
    open func pbPhotoKeyInIndexPath(_ indexPath:IndexPath) -> String?
    {
        return nil
    }
    
    /// 返回单元格中的网络图片链接（不设置则无网络图片下载任务）
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    open func pbPhotoUrlInIndexPath(_ indexPath:IndexPath, data: AnyObject?) -> String?
    {
        return nil
    }
    
    /// 设置下载图片的序列，只下载显示区域内的图片
    open func pbSetQueueForDisplayRow()
    {
        if let pathArray = self.collectionView?.indexPathsForVisibleItems
        {
            //创建一个包含所有等待任务的集合
            let allPendingOperations = NSMutableSet(array:Array(self.photoManager.downloadsInProgress.keys))
            
            //构建一个需要撤销的任务的集合，从所有任务中除掉可见行的index path
            let toBeCancelled=allPendingOperations.mutableCopy() as! NSMutableSet
            let visiblePaths=NSSet(array: pathArray)
            toBeCancelled.minus(visiblePaths as Set<NSObject>)
            
            //创建一个需要执行的任务的集合,从所有可见index path的集合中除去那些已经在等待队列中的
            let toBeStarted=visiblePaths.mutableCopy() as! NSMutableSet
            toBeStarted.minus(allPendingOperations as Set<NSObject>)
            
            //遍历需要撤销的任务，撤消它们
            for indexPath in toBeCancelled
            {
                self.photoManager.downloadCancel(indexPath as! IndexPath)
            }
            
            //遍历需要开始的任务
            for indexPath in toBeStarted
            {
                let indexPath=indexPath as! IndexPath
                if(self.pbIsLoadCellForDataLoad(indexPath)){continue}
                
                //获取单元对应数据
                var data=self.pbResolveDataInIndexPath(indexPath)
                if(data == nil)
                {
                    data=(self.collectionData?.object(at: (indexPath as NSIndexPath).row)) as? NSDictionary
                }
                self.pbAddPhotoTaskToQueue(indexPath,data: data)
            }
        }
    }
    
    /// 添加图片下载任务到队列
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    open func pbAddPhotoTaskToQueue(_ indexPath:IndexPath,data:AnyObject?)
    {
        if let record=self.photoData[indexPath]
        {
            switch(record.state)
            {
            case .new:
                self.photoManager.download(record, callback: { (photoRecord) -> Void in
                    
                    self.collectionView?.reloadItems(at: [indexPath])
                    
                    },imageFilter:{ (image:UIImage)->UIImage? in
                        
                        return self.pbImageFilterForCell(image, indexPath: indexPath, data: data)
                })
            default:
                _=0
            }
        }
    }
    
    /// 获取指定位置的图片尺寸
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    open func pbGetPhotoImageSize(_ indexPath:IndexPath,data:AnyObject?) -> CGSize?
    {
        return nil
    }
    
    /// 设置图片载入滤镜处理
    /// - parameter image       :图片
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    open func pbImageFilterForCell(_ image:UIImage,indexPath:IndexPath,data:AnyObject?) -> UIImage?
    {
        if let size=self.pbGetPhotoImageSize(indexPath, data: data)
        {
            //滤镜处理：缩放图片
            let isLand=(image.size.width>image.size.height)
            let scale=isLand ? (size.height/image.size.height):(size.width/image.size.width)
            return UIImage.pbScale(image,scale:scale)
        }
        return nil
    }
    
    /// 根据给定的路径获取全路径
    /// - parameter url:链接地址
    open func pbFullUrlForDataLoad(_ url:String?) -> String?
    {
        var result=url
        
        if(result != nil)
        {
            if(result!.hasPrefix("http"))
            {
                
            }
            else
            {
                result=PbDataAppController.instance.server+result!
            }
        }
        
        return result
    }
    
    /// 是否是显示载入单元格
    /// - parameter indexPath   :单元格位置索引
    open func pbIsLoadCellForDataLoad(_ indexPath:IndexPath) -> Bool
    {
        return self.pbSupportFooterLoad() && (indexPath as NSIndexPath).row == self.collectionData?.count
    }
    
    /*-----------------------结束：公共方法*/
    
    /*-----------------------开始：实现PbUICollectionViewControllerProtocol*/
    
    // 数据适配器初始化时调用
    open func pbDoInitForDataLoad(_ delegate:PbUIViewControllerProtocol?)
    {
        //增加顶部刷新视图
        if(self.pbSupportHeaderRefresh())
        {
            self.collectionView?.pbAddUIRefreshViewToHeader({ () -> Void in
                self.pbLoadData(PbDataUpdateMode.update)
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
    
    // 返回当前数据访问使用的链接标识
    open func pbKeyForDataLoad() -> String?
    {
        return nil
    }
    
    // 返回当前数据访问使用的参数
    open func pbParamsForDataLoad(_ updateMode:PbDataUpdateMode) -> NSMutableDictionary?
    {
        return NSMutableDictionary()
    }
    
    // 返回当前数据访问使用的页码参数名称
    open func pbPageKeyForDataLoad() -> String
    {
        return "page"
    }
    
    // 设置数据请求回执附带属性
    //请求返回时附带页码参数
    open func pbPropertyForDataLoad(_ updateMode:PbDataUpdateMode) -> NSDictionary?
    {
        return nil
    }
    
    // 开始请求前处理
    open func pbWillRequestForDataLoad(_ updateMode:PbDataUpdateMode)
    {
        if(self.pbSupportHeaderRefresh())
        {
            self.collectionView?.pbUIRefreshHeaderSetUpdateTime(Date())
        }
    }
    
    // 出现访问错误时调用
    open func pbErrorForDataLoad(_ type:PbUIViewControllerErrorType,error:String)
    {
    }
    
    // 解析处理返回的数据
    open func pbResolveFromResponse(_ response:NSDictionary) -> AnyObject?
    {
        return nil
    }
    
    // 解析处理返回的数据
    open func pbResolveFromResponse(_ response:NSDictionary,updateMode:PbDataUpdateMode) -> AnyObject?
    {
        return nil
    }
    
    // 执行更新类相关返回后的处理
    open func pbDoUpdateForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
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
        
        if((updateMode == PbDataUpdateMode.update) || (updateMode == PbDataUpdateMode.first && !self.pbAutoUpdateAfterFirstLoad()))
        {
            //设置非初次载入
            self.dataAdapter?.isInitLoad=false
        }
    }
    
    // 执行增量类相关返回后的处理
    open func pbDoInsertForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        let newData=response as? NSArray
        if(self.collectionData == nil){self.collectionData=NSMutableArray()}
        
        if((newData != nil) && (newData!.count > 0))
        {
            //增加表格数据
            self.collectionData?.addObjects(from: newData! as [AnyObject])
            
            //设置表格动态增加索引
            let insertPaths=NSMutableArray(capacity:newData!.count)
            //获取增量对应的节点
            let targetSection=self.pbSectionForInsertData()
            
            //设置增量数据配置数组
            for i in 0 ..< newData!.count
            {
                let newPath=IndexPath(row:(self.collectionData?.index(of: newData!.object(at: i)))!, section: targetSection)
                insertPaths.add(newPath)
            }
            
            //增量增加表格数据
            self.collectionView?.insertItems(at: (insertPaths as [AnyObject]) as! [IndexPath])
        }
        else
        {
            //记录下页无数据状态
            self.dataAdapter?.nextIsNull=true
            
            if(self.pbSupportFooterLoad())
            {
                self.collectionView?.deleteItems(at: [self.collectionView!.indexPath(for: self.loadCollectionCell!)!])
            }
        }
    }
    
    // 执行相关返回后的视图更新处理
    open func pbDoUIDisplayForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    // 执行数据载入结束后的处理
    open func pbDoEndForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        //结束顶部视图载入状态
        if(self.pbSupportHeaderRefresh() && (updateMode==PbDataUpdateMode.update))
        {
            self.collectionView?.pbUIRefreshHeaderEnd()
        }
        
        //结束底部载入指示器
        if(self.pbSupportFooterLoad() && (updateMode==PbDataUpdateMode.nextPage))
        {
            self.loadCollectionCell?.stopLoadAnimating()
        }
    }
    
    // 初次载入后是否立即更新
    open func pbAutoUpdateAfterFirstLoad() -> Bool
    {
        return true
    }
    
    // 放回插入数据时对应的分组值
    func pbSectionForInsertData() -> Int
    {
        return 0
    }
    
    // 是否支持载入显示器
    open func pbSupportActivityIndicator() -> PbUIActivityIndicator?
    {
        let indicator=PbUIRingSpinnerCoverView(frame:CGRect(x: 0, y: 0, width: 2000, height: 2000))
        indicator.center=self.view.center
        indicator.tintColor=self.pbUIRefreshActivityDefaultColor()
        indicator.backgroundColor=UIColor.white
        indicator.stopAnimating()
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        
        self.view.layoutIfNeeded()
        
        return indicator
    }
    
    // 是否支持表格顶部刷新
    open func pbSupportHeaderRefresh() -> Bool
    {
        return true
    }
    
    // 表格顶部刷新的颜色
    open func pbSupportHeaderRefreshColor() -> UIColor?
    {
        return nil
    }
    
    // 是否支持表格底部载入
    open func pbSupportFooterLoad() -> Bool
    {
        return true
    }
    
    // 返回表格底部载入类型
    open func pbSupportFooterLoadType() -> PbUIViewType
    {
        return PbUIViewType.auto
    }
    
    // 表格底部载入主题颜色（tiniColor）
    open func pbSupportFooterLoadColor() -> UIColor?
    {
        return nil
    }
    
    // 获取指定单元格位置的数据
    open func pbResolveDataInIndexPath(_ indexPath:IndexPath) -> AnyObject?
    {
        return nil
    }
    
    // 获取指定的载入指示器
    open func pbLoadCellInIndexPath(_ indexPath:IndexPath) -> UICollectionViewCell?
    {
        var result:UICollectionViewCell?
        
        if(self.pbSupportFooterLoad()&&(indexPath as NSIndexPath).row==self.collectionData?.count)
        {
            self.collectionView?.register(PbUICollectionViewCellForLoad.self, forCellWithReuseIdentifier:loadCellIdentifier)
            result=self.collectionView?.dequeueReusableCell(withReuseIdentifier: loadCellIdentifier, for: indexPath)
            
            self.loadCollectionCell=result as? PbUICollectionViewCellForLoad
            if let color = self.pbSupportFooterLoadColor()
            {
                self.loadCollectionCell?.setIndicatorTiniColor(color)
            }
            //                self.loadCollectionCell?.startLoadAnimating()
            return result
        }
        
        return nil
    }
    
    // 返回指定位置的单元格标识
    open func pbIdentifierForCollectionView(_ indexPath:IndexPath,data:AnyObject?) -> String
    {
        return "PbUICollectionViewDataCell"
    }
    
    // 返回指定位置单元格使用的资源文件
    open func pbNibNameForCollectionView(_ indexPath:IndexPath,data:AnyObject?) -> String?
    {
        return nil
    }
    
    // 返回指定位置单元格的类
    open func pbCellClassForCollectionView(_ indexPath:IndexPath,data:AnyObject?) -> AnyClass?
    {
        return nil
    }
    
    // 设置表格数据显示
    open func pbSetDataForCollectionView(_ cell:AnyObject,data:AnyObject?,photoRecord:PbDataPhotoRecord?,indexPath:IndexPath) -> AnyObject
    {
        return cell
    }
    
    /*-----------------------结束：实现PbUICollectionViewControllerProtocol*/
    
    /*-----------------------开始：实现UICollectionViewDataSource*/
    
    // 返回每节网格内的网格数
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
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
    
    // 返回每节每个网格的单元样式
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var result:UICollectionViewCell?
        
        if(self.collectionData != nil)
        {
            //使用底部载入单元格
            if let result=self.pbLoadCellInIndexPath(indexPath)
            {
                return result
            }
            
            //获取单元对应数据
            var data=self.pbResolveDataInIndexPath(indexPath)
            if(data == nil)
            {
                data=self.collectionData?.object(at: (indexPath as NSIndexPath).row) as AnyObject?
            }
            
            //获取并记录单元数据中的网络图片
            var imageRecord:PbDataPhotoRecord?=self.photoData[indexPath]
            if(imageRecord == nil)
            {
                if let photoKey = self.pbPhotoKeyInIndexPath(indexPath)
                {
                    if let photoUrl = data?.object(forKey: photoKey)
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
                self.collectionView!.register(UINib(nibName:nibName, bundle:Bundle.main), forCellWithReuseIdentifier: self.pbIdentifierForCollectionView(indexPath, data: data))
            }
            if let cellClass: AnyClass=self.pbCellClassForCollectionView(indexPath, data: data)
            {
                self.collectionView?.register(cellClass, forCellWithReuseIdentifier:self.pbIdentifierForCollectionView(indexPath, data: data))
            }
            
            //获取未使用的单元对象
            let identifier=self.pbIdentifierForCollectionView(indexPath, data: data)
            result=(self.collectionView?.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath))
            
            //创建表格单元对象
            if(result == nil)
            {
                result=UICollectionViewCell()
            }
            
            //设置数据
            result=(self.pbSetDataForCollectionView(result!,data: data,photoRecord:imageRecord,indexPath: indexPath)) as? UICollectionViewCell
            
            //关闭指示器
            if((indexPath as NSIndexPath).row==1&&(indexPath as NSIndexPath).section==0)
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
    
    // 滚动视图开始拖动
    override open func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        //挂起全部图片载入任务
        self.photoManager.downloadPauseAll()
    }
    
    // 滚动视图结束拖动
    override open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        //只载入显示区域内的图片
        self.pbSetQueueForDisplayRow()
        //继续载入任务
        self.photoManager.downloadResumeAll()
    }
    
    // 滚动视图结束减速
    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        //只载入显示区域内的图片
//        self.pbSetQueueForDisplayRow()
        //继续载入任务
//        self.photoManager.downloadResumeAll()
        
        //到达尾部时载入下页
        if(self.pbSupportFooterLoad())
        {
            if let pathArray = self.collectionView?.indexPathsForVisibleItems
            {
                for indexPath in pathArray
                {
                    let indexPath:IndexPath=indexPath 
                    if(indexPath == IndexPath(row:self.collectionData!.count, section:(indexPath as NSIndexPath).section)&&(!self.dataAdapter!.nextIsNull)&&(!self.dataAdapter!.isInitLoad)&&(!self.dataAdapter!.isDataLoading))
                    {
                        //显示翻页载入指示器
                        self.loadCollectionCell?.startLoadAnimating()
                        
                        //载入下页数据
                        self.pbLoadData(PbDataUpdateMode.nextPage)
                    }
                }
            }
        }
    }
    
    /*-----------------------结束：实现UIScrollViewDelegate*/
    
    /*-----------------------开始：实现PbUIRefreshConfigProtocol*/
    
    open func pbUIRefreshViewBackgroudColor() -> UIColor{return UIColor.clear}
    open func pbUIRefreshLabelFontSize() -> CGFloat{return 12}
    open func pbUIRefreshLabelTextColor() -> UIColor{return UIColor.darkGray}
    open func pbUIRefreshActivityView() -> PbUIActivityIndicator?{return nil}
    open func pbUIRefreshActivityDefaultSize() -> CGSize{return CGSize(width: 32,height: 32)}
    open func pbUIRefreshActivityDefaultColor() -> UIColor{return UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1)}
    
    /*-----------------------结束：实现PbUIRefreshConfigProtocol*/
}
