//
//  PbUITableViewController.swift
//  pb.swift.ui
//  实现UIViewController中的扩展协议，创建表格视图父类，增加数据绑定载入方法
//  Created by Maqiang on 15/6/29.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

public class PbUITableViewController:UITableViewController,PbUITableViewControllerProtocol,PbUIRefreshConfigProtocol
{
    //loadCellIdentifier
    let loadCellIdentifier="PbUITableViewLoadCell"
    
    //tableData:记录当前的表格使用数据
    var tableData:NSMutableArray?
    //dataAdapter:当前使用的数据适配器
    var dataAdapter:PbDataAdapter?
    //loadTableCell:底部载入单元格
    var loadTableCell:PbUITableViewCellForLoad?
    //photoData:记录表格对应的列表
    var photoData=[NSIndexPath:PbDataPhotoRecord]()
    //photoManager:图片载入管理器对象
    lazy var photoManager=PbDataPhotoManager(downloadMaxCount:1)
    
    /*-----------------------开始：公共方法*/
    
    //pbLoadData:获取数据
    func pbLoadData(updateMode:PbDataUpdateMode)
    {
        if(self.dataAdapter == nil){self.dataAdapter=PbDataAdapter(delegate: self)}
        self.dataAdapter?.loadData(updateMode)
    }
    
    //pbDoForHeaderRefreshEvent:顶部更新时处理
    func pbDoForHeaderRefreshEvent()
    {
        self.pbLoadData(PbDataUpdateMode.Update)
    }
    
    //pbNormalHeightForRowAtIndexPath:返回正常单元格的高度
    func pbNormalHeightForRowAtIndexPath(tableView: UITableView,indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
    //pbLoadHeightForRowAtIndexPath:返回载入单元格的高度
    func pbLoadHeightForRowAtIndexPath(tableView: UITableView,indexPath: NSIndexPath) -> CGFloat
    {
        return 34
    }
    
    //pbPhotoKeyInIndexPath:返回单元格中的网络图片标识（不设置则无网络图片下载任务）
    func pbPhotoKeyInIndexPath(indexPath:NSIndexPath) -> String?
    {
        return nil
    }
    
    //pbSetQueueForDisplayRow:设置下载图片的序列，只下载显示区域内的图片
    func pbSetQueueForDisplayRow()
    {
        if let pathArray = self.tableView.indexPathsForVisibleRows
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
                    data=(self.tableData?.objectAtIndex(indexPath.row)) as? NSDictionary
                }
                self.pbAddPhotoTaskToQueue(indexPath,data: data)
            }
        }
    }
    
    //pbAddPhotoTaskToQueue:添加图片下载任务到队列
    func pbAddPhotoTaskToQueue(indexPath:NSIndexPath,data:NSDictionary?)
    {
        if let record=self.photoData[indexPath]
        {
            switch(record.state)
            {
                case .New:
                    self.photoManager.download(record, callback: { (photoRecord) -> Void in
                        
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        
                    })
                default:
                    _=0
            }
        }
    }
    
    //pbFullUrlForDataLoad:根据给定的路径获取全路径
    func pbFullUrlForDataLoad(url:String?) -> String?
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
    func pbIsLoadCellForDataLoad(indexPath:NSIndexPath) -> Bool
    {
        return self.pbSupportFooterLoad() && indexPath.row == self.tableData?.count
    }
    
    /*-----------------------结束：公共方法*/
    
    /*-----------------------开始：实现PbUITableViewControllerProtocol*/
    
    //pbDoInitForDataLoad:数据适配器初始化时调用
    func pbDoInitForDataLoad(delegate:PbUIViewControllerProtocol?)
    {
        //初始化顶部刷新
        if(self.pbSupportHeaderRefresh())
        {
            switch(self.pbSupportHeaderRefreshType())
            {
                case .system:
                    
                    self.refreshControl=UIRefreshControl()
                    if let color = self.pbSupportHeaderRefreshColor()
                    {
                        self.refreshControl?.tintColor=color
                    }
                    self.refreshControl?.addTarget(self, action: "pbDoForHeaderRefreshEvent", forControlEvents: UIControlEvents.ValueChanged)
                    
                    break
                
                case .pull:
                
                    self.tableView.pbAddUIRefreshViewToHeader({ () -> Void in
                        self.pbDoForHeaderRefreshEvent()
                    },delegate:self)
                    
                    break
                
                default:
                    break
            }
        }
        
        //初始化底部载入刷新
        if(self.pbSupportFooterLoad())
        {
            self.loadTableCell=PbUITableViewCellForLoad(style: UITableViewCellStyle.Default, reuseIdentifier:loadCellIdentifier)
            if let color = self.pbSupportFooterLoadColor()
            {
                self.loadTableCell?.setIndicatorTiniColor(color)
            }
            
//            switch(self.pbSupportHeaderRefreshType())
//            {
//                case .auto:
//                    
//                    self.loadTableCell=PbUITableViewCellForLoad(style: UITableViewCellStyle.Default, reuseIdentifier:loadCellIdentifier)
//                    if let color = self.pbSupportFooterLoadColor()
//                    {
//                        self.loadTableCell?.setIndicatorTiniColor(color)
//                    }
//                
//                    break
//                
//                case .pull:
//                    
//                
//                    self.tableView.pbAddUIRefreshViewToFooter({ () -> Void in
//                        self.pbLoadData(PbDataUpdateMode.NextPage)
//                    })
//                
//                    break
//                
//                default:
//                    break
//            }
        }
    }
    
    //pbKeyForDataLoad:返回当前数据访问使用的链接标识
    func pbKeyForDataLoad() -> String?
    {
        return nil
    }
    
    //pbParamsForDataLoad:返回当前数据访问使用的参数
    func pbParamsForDataLoad(updateMode:PbDataUpdateMode) -> NSMutableDictionary?
    {
        return NSMutableDictionary()
    }
    
    //pbPageKeyForDataLoad:返回当前数据访问使用的页码参数名称
    func pbPageKeyForDataLoad() -> String
    {
        return "page"
    }
    
    //pbPropertyForDataLoad:设置数据请求回执附带属性
    //请求返回时附带页码参数
    func pbPropertyForDataLoad(updateMode:PbDataUpdateMode) -> NSDictionary?
    {
        return nil
    }
    
    //pbWillRequestForDataLoad:开始请求前处理
    func pbWillRequestForDataLoad(updateMode:PbDataUpdateMode)
    {
        if(self.pbSupportHeaderRefresh())
        {
            self.tableView?.pbUIRefreshHeaderSetUpdateTime(NSDate())
        }
    }
    
    //pbErrorForDataLoad:出现访问错误时调用
    func pbErrorForDataLoad(type:PbUIViewControllerErrorType,error:String)
    {
    }
    
    //pbResolveFromResponse:解析处理返回的数据
    func pbResolveFromResponse(response:NSDictionary) -> AnyObject?
    {
        return nil
    }
    
    //pbDoUpdateForDataLoad:执行更新类相关返回后的处理
    func pbDoUpdateForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        if(response == nil){return}
        
        //新数据对比，数据相同则不做处理
        let newData=response as! NSArray
        if(self.tableData != (response as! NSArray))
        {
            //记录数据
            self.tableData=NSMutableArray(array:newData)
            
            //刷新表格数据
            self.tableView.reloadData()
        }
        
        if((updateMode == PbDataUpdateMode.Update) || (updateMode == PbDataUpdateMode.First && !self.pbAutoUpdateAfterFirstLoad()))
        {
            //设置非初次载入
            self.dataAdapter?.isInitLoad=false
        }
    }
    
    //pbDoInsertForDataLoad:执行增量类相关返回后的处理
    func pbDoInsertForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        let newData=response as? NSArray
        if(self.tableData == nil){self.tableData=NSMutableArray()}
        
        self.tableView.beginUpdates()
        if((newData != nil) && (newData!.count > 0))
        {
            //增加表格数据
            self.tableData?.addObjectsFromArray(newData as! [AnyObject])
            
            //设置表格动态增加索引
            let insertPaths=NSMutableArray(capacity:newData!.count)
            //获取增量对应的节点
            let targetSection=self.pbSectionForInsertData()
            
            //设置增量数据配置数组
            for (var i=0; i<newData!.count; i++)
            {
                let newPath=NSIndexPath(forRow:(self.tableData?.indexOfObject(newData!.objectAtIndex(i)))!, inSection: targetSection)
                insertPaths.addObject(newPath)
            }
            
            //增量增加表格数据
            self.tableView.insertRowsAtIndexPaths((insertPaths as [AnyObject]) as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        else
        {
            //记录下页无数据状态
            self.dataAdapter?.nextIsNull=true
            
            if(self.pbSupportFooterLoad())
            {
                self.tableView.deleteRowsAtIndexPaths([self.tableView.indexPathForCell(self.loadTableCell!)!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
        self.tableView.endUpdates()
    }
    
    //pbDoUIDisplayForDataLoad:执行相关返回后的视图更新处理
    func pbDoUIDisplayForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbDoEndForDataLoad:执行数据载入结束后的处理
    func pbDoEndForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
        //结束顶部视图载入状态
        if(self.pbSupportHeaderRefresh() && (updateMode==PbDataUpdateMode.Update))
        {
            switch(self.pbSupportHeaderRefreshType())
            {
                case .system:
                    self.refreshControl?.endRefreshing()
                    break
                
                case .pull:
                    self.tableView.pbUIRefreshHeaderEnd()
                    break
                
                default:
                    break
            }
        }
        
        //结束底部载入指示器
        if(self.pbSupportFooterLoad() && (updateMode==PbDataUpdateMode.NextPage))
        {
            self.loadTableCell?.stopLoadAnimating()
        }
    }
    
    //pbAutoUpdateAfterFirstLoad:初次载入后是否立即更新
    func pbAutoUpdateAfterFirstLoad() -> Bool
    {
        return true
    }
    
    //pbSectionForInsertData:放回插入数据时对应的分组值
    func pbSectionForInsertData() -> Int
    {
        return 0
    }
    
    //pbSupportActivityIndicator:是否支持载入显示器
    func pbSupportActivityIndicator() -> PbUIActivityIndicator?
    {
        let indicator=PbUIRingSpinnerCoverView(frame:CGRectMake(0, 0, 2000, 2000))
        indicator.center=self.view.center
        indicator.tintColor=UIColor(red:215/255, green: 49/255, blue: 69/255, alpha: 1)
        indicator.backgroundColor=UIColor.whiteColor()
        indicator.stopAnimating()
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        
        self.view.layoutIfNeeded()
        
        return indicator
    }
    
    //pbSupportHeaderRefresh:是否支持表格顶部刷新
    func pbSupportHeaderRefresh() -> Bool
    {
        return true
    }
    
    //pbSupportHeaderRefreshType:返回表格顶部刷新视图类型
    func pbSupportHeaderRefreshType() -> PbUIViewType
    {
        return PbUIViewType.pull
    }
    
    //pbSupportHeaderRefreshColor:表格顶部刷新的颜色
    func pbSupportHeaderRefreshColor() -> UIColor?
    {
        return nil
    }
    
    //pbSupportFooterLoad:是否支持表格底部载入
    func pbSupportFooterLoad() -> Bool
    {
        return true
    }
    
    //pbSupportFooterLoadType:返回表格底部载入类型
    func pbSupportFooterLoadType() -> PbUIViewType
    {
        return PbUIViewType.auto
    }
    
    //pbSupportFooterLoadColor:表格底部载入主题颜色（tiniColor）
    func pbSupportFooterLoadColor() -> UIColor?
    {
        return nil
    }
    
    //pbResolveDataInIndexPath:获取指定单元格位置的数据
    func pbResolveDataInIndexPath(indexPath:NSIndexPath) -> NSDictionary?
    {
        return nil
    }
    
    //pbIdentifierForTableView:返回指定位置的单元格标识
    func pbIdentifierForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> String
    {
        return "PbUITableViewDataCell"
    }
    
    //pbNibNameForTableView:返回指定位置单元格使用的资源文件
    func pbNibNameForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> String?
    {
        return nil
    }
    
    //pbNibIndexForTableView:返回指定位置单元格使用的资源文件
    func pbNibIndexForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> Int
    {
        return 0
    }
    
    //pbInitCellForTableView:返回自定义的单元格对象
    func pbInitCellForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> AnyObject?
    {
        return nil
    }
    
    //pbSetDataForTableView:设置表格数据显示
    func pbSetDataForTableView(cell:AnyObject,data:NSDictionary?,photoRecord:PbDataPhotoRecord?,indexPath:NSIndexPath) -> AnyObject
    {
        return cell
    }
    
    /*-----------------------结束：实现PbUITableViewControllerProtocol*/
    
    /*-----------------------开始：实现UITableViewDataSource*/
    
    //tableView:heightForRowAtIndexPath:返回列表单元格的高度
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var result:CGFloat=self.pbNormalHeightForRowAtIndexPath(tableView, indexPath: indexPath)
        
        if(self.tableData != nil && self.tableData?.count>0 && self.pbIsLoadCellForDataLoad(indexPath))
        {
            result=((self.dataAdapter!.nextIsNull) || (self.dataAdapter!.isInitLoad) ? 0 : self.pbLoadHeightForRowAtIndexPath(tableView, indexPath: indexPath))
        }
        
        return result
    }
    
    //tableView:numberOfRowsInSection:返回列表数据的数据量
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var result=0
        
        if(self.tableData != nil)
        {
            result=self.tableData!.count
            result=((self.pbSupportFooterLoad()) && (!self.dataAdapter!.nextIsNull)) ?(result+1):result
        }
        
        return result
    }
    
    //tableView:cellForRowAtIndexPath:返回指定索引对应的列表项
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var result:UITableViewCell?
        
        if(self.tableData != nil)
        {
            //使用底部载入单元格
            if(self.pbSupportFooterLoad()&&indexPath.row==self.tableData?.count)
            {
                self.loadTableCell?.startLoadAnimating()
                return self.loadTableCell!
            }
            
            //获取单元对应数据
            var data=self.pbResolveDataInIndexPath(indexPath)
            if(data == nil)
            {
                data=(self.tableData?.objectAtIndex(indexPath.row)) as? NSDictionary
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
            }
            
            //获取未使用的单元对象
            let identifier=self.pbIdentifierForTableView(indexPath, data: data)
            result=(self.tableView.dequeueReusableCellWithIdentifier(identifier))
            
            //创建表格单元对象
            if(result == nil)
            {
                //使用资源文件创建
                if let nibName=self.pbNibNameForTableView(indexPath, data: data)
                {
                    //获取资源文件
                    let nib=(NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil)) as NSArray
                    //获取设置索引
                    let index=self.pbNibIndexForTableView(indexPath, data: data)
                    //获取单元格对象
                    result=(nib.objectAtIndex(index)) as? UITableViewCell
                }
                //使用自定义单元格类创建
                else
                {
                    result=(self.pbInitCellForTableView(indexPath, data: data)) as? UITableViewCell
                }
                
                //使用默认创建
                if(result == nil)
                {
                    result=UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:identifier)
                }
            }
            
            //设置数据
            result=(self.pbSetDataForTableView(result!,data: data,photoRecord:imageRecord,indexPath: indexPath)) as? UITableViewCell
            
            //关闭指示器
            if(indexPath.row==1&&indexPath.section==0)
            {
                self.dataAdapter?.indicator?.stopAnimating()
            }
        }
        else
        {
            result=UITableViewCell()
        }
        
        return result!
    }
    
    /*-----------------------结束：实现UITableViewDataSource*/
    
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
        //self.pbSetQueueForDisplayRow()
        //继续载入任务
        //self.photoManager.downloadResumeAll()
    }
    
    //scrollViewDidEndDecelerating:滚动视图结束减速
    override public func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        //只载入显示区域内的图片
        self.pbSetQueueForDisplayRow()
        //继续载入任务
        self.photoManager.downloadResumeAll()
        
        //到达尾部时载入下页
        if(self.pbSupportFooterLoad())
        {
            if let pathArray = self.tableView.indexPathsForVisibleRows
            {
                for indexPath in pathArray
                {
                    let indexPath:NSIndexPath=indexPath 
                    if(indexPath == NSIndexPath(forRow:self.tableData!.count, inSection:indexPath.section)&&(!self.dataAdapter!.nextIsNull)&&(!self.dataAdapter!.isInitLoad)&&(!self.dataAdapter!.isDataLoading))
                    {
                        //显示翻页载入指示器
                        self.loadTableCell?.startLoadAnimating()
                        
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