//
//  PbDataAdapter.swift
//  pb.swift.data
//  数据绑定器，增加新的委托协议，用于为视图控制器增加数据载入流程等方法
//  Created by Maqiang on 15/6/29.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

public enum PbUIViewControllerErrorType:Int
{
    case NetNotConnected,NetFailed,NetError,ServerError
}

public enum PbUIViewType:Int
{
    case none,system,pull,auto
}

public protocol PbUIActivityIndicator
{
    func startAnimating()
    func stopAnimating()
}

public protocol PbUIViewControllerProtocol
{
    //pbDoInitForDataLoad:数据适配器初始化时调用
    func pbDoInitForDataLoad(delegate:PbUIViewControllerProtocol?)
    //pbKeyForDataLoad:返回当前数据访问使用的链接标识
    func pbKeyForDataLoad() -> String?
    //pbParamsForDataLoad:返回当前数据访问使用的参数
    func pbParamsForDataLoad(updateMode:PbDataUpdateMode) -> NSMutableDictionary?
    //pbPageKeyForDataLoad:返回当前数据访问使用的页码参数名称
    func pbPageKeyForDataLoad() -> String
    //pbPropertyForDataLoad:设置数据请求回执附带属性
    func pbPropertyForDataLoad(updateMode:PbDataUpdateMode) -> NSDictionary?
    //pbWillRequestForDataLoad:开始请求前处理
    func pbWillRequestForDataLoad(updateMode:PbDataUpdateMode)
    //pbErrorForDataLoad:出现访问错误时调用
    func pbErrorForDataLoad(type:PbUIViewControllerErrorType,error:String)
    //pbResolveFromResponse:解析处理返回的数据
    func pbResolveFromResponse(response:NSDictionary) -> AnyObject?
    //pbDoUpdateForDataLoad:执行更新类相关返回后的处理
    func pbDoUpdateForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    //pbDoInsertForDataLoad:执行增量类相关返回后的处理
    func pbDoInsertForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    //pbDoUIDisplayForDataLoad:执行相关返回后的视图更新处理
    func pbDoUIDisplayForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    //pbDoEndForDataLoad:执行数据载入结束后的处理
    func pbDoEndForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    //pbAutoUpdateAfterFirstLoad:初次载入后是否立即更新
    func pbAutoUpdateAfterFirstLoad() -> Bool
    //pbSupportActivityIndicator:是否支持载入显示器
    func pbSupportActivityIndicator() -> PbUIActivityIndicator?
}

public protocol PbUITableViewControllerProtocol:PbUIViewControllerProtocol
{
    //pbSupportHeaderRefresh:是否支持表格顶部刷新
    func pbSupportHeaderRefresh() -> Bool
    
    //pbSupportHeaderRefreshType:返回表格顶部刷新视图类型
    func pbSupportHeaderRefreshType() -> PbUIViewType
    
    //pbSupportHeaderRefreshColor:表格顶部刷新的主题颜色（tiniColor）
    func pbSupportHeaderRefreshColor() -> UIColor?
    
    //pbSupportFooterLoad:是否支持表格底部载入
    func pbSupportFooterLoad() -> Bool
    
    //pbSupportFooterLoadType:返回表格底部载入类型
    func pbSupportFooterLoadType() -> PbUIViewType
    
    //pbSupportFooterLoadColor:表格底部载入主题颜色（tiniColor）
    func pbSupportFooterLoadColor() -> UIColor?
    
    //pbResolveDataInIndexPath:获取指定单元格位置的数据
    func pbResolveDataInIndexPath(indexPath:NSIndexPath) -> NSDictionary?
    
    //pbIdentifierForTableView:返回指定位置的单元格标识
    func pbIdentifierForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> String
    
    //pbNibNameForTableView:返回指定位置单元格使用的资源文件
    func pbNibNameForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> String?
    
    //pbNibIndexForTableView:返回指定位置单元格使用的资源文件
    func pbNibIndexForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> Int
    
    //pbInitCellForTableView:返回自定义的单元格对象
    func pbInitCellForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> AnyObject?
    
    //pbSetDataForTableView:设置表格数据显示
    func pbSetDataForTableView(cell:AnyObject,data:NSDictionary?,photoRecord:PbDataPhotoRecord?,indexPath:NSIndexPath) -> AnyObject
}

public protocol PbUICollectionViewControllerProtocol:PbUIViewControllerProtocol
{
    //pbSupportHeaderRefresh:是否支持表格顶部刷新
    func pbSupportHeaderRefresh() -> Bool
    
    //pbSupportHeaderRefreshColor:表格顶部刷新的主题颜色（tiniColor）
    func pbSupportHeaderRefreshColor() -> UIColor?
    
    //pbSupportFooterLoad:是否支持表格底部载入
    func pbSupportFooterLoad() -> Bool
    
    //pbSupportFooterLoadType:返回表格底部载入类型
    func pbSupportFooterLoadType() -> PbUIViewType
    
    //pbSupportFooterLoadColor:表格底部载入主题颜色（tiniColor）
    func pbSupportFooterLoadColor() -> UIColor?
    
    //pbResolveDataInIndexPath:获取指定单元格位置的数据
    func pbResolveDataInIndexPath(indexPath:NSIndexPath) -> NSDictionary?
    
    //pbIdentifierForCollectionView:返回指定位置的单元格标识
    func pbIdentifierForCollectionView(indexPath:NSIndexPath,data:NSDictionary?) -> String
    
    //pbNibNameForCollectionView:返回指定位置单元格使用的资源文件
    func pbNibNameForCollectionView(indexPath:NSIndexPath,data:NSDictionary?) -> String?
    
    //pbCellClassForCollectionView:返回指定位置单元格的类
    func pbCellClassForCollectionView(indexPath:NSIndexPath,data:NSDictionary?) -> AnyClass?
    
    //pbSetDataForCollectionView:设置网格数据显示
    func pbSetDataForCollectionView(cell:AnyObject,data:NSDictionary?,photoRecord:PbDataPhotoRecord?,indexPath:NSIndexPath) -> AnyObject
}

public class PbDataAdapter
{
    //delegate:数据处理方法绑定委托
    var delegate:PbUIViewControllerProtocol?
    var indicator:PbUIActivityIndicator?
    
    //pageNum:记录当前的列表访问页码
    lazy var pageNum=1
    //nextIsNull:下一页是否为空
    lazy var nextIsNull=false
    //isInitLoad:是否初始化载入
    lazy var isInitLoad=true
    //isDataLoading:是否在数据载入中
    lazy var isDataLoading=false
    
    //init:初始化方法
    init(delegate:PbUIViewControllerProtocol?)
    {
        self.delegate=delegate
        self.delegate?.pbDoInitForDataLoad(delegate)
        
        //初始化载入指示器
        self.indicator=self.delegate?.pbSupportActivityIndicator()
    }
    
    //loadData:加载网络数据
    func loadData(updateMode:PbDataUpdateMode)
    {
        if(self.delegate == nil){return}
        
        //判断获取模式
        var getMode=PbDataGetMode.FromLocalOrNet
        var toPage=self.pageNum
        if(updateMode == PbDataUpdateMode.First)
        {
            toPage=1
            getMode=PbDataGetMode.FromLocal
            self.nextIsNull=false
            self.isInitLoad=true
        }
        else if(updateMode == PbDataUpdateMode.Update)
        {
            toPage=1
            getMode=PbDataGetMode.FromNet
            self.nextIsNull=false
        }
        else if(updateMode == PbDataUpdateMode.NextPage)
        {
            toPage++
            getMode=PbDataGetMode.FromLocalOrNet
        }
        else
        {
            return
        }
        
        //指定标识则执行数据获取流程
        if let key = self.delegate!.pbKeyForDataLoad()
        {
            //如果为第一次载入，显示载入指示器
            if(updateMode == PbDataUpdateMode.First)
            {
                self.indicator?.startAnimating()
            }
            else
            {
                self.isDataLoading=true
            }
            
            //设置请求参数
            var params=self.delegate!.pbParamsForDataLoad(updateMode)
            params=(params != nil) ? params : NSMutableDictionary()
            //增加页码参数
            params?.setObject(toPage,forKey:self.delegate!.pbPageKeyForDataLoad())
            //回执附带属性
            let property=self.delegate!.pbPropertyForDataLoad(updateMode)
            
            //载入数据
            self.delegate!.pbWillRequestForDataLoad(updateMode)
            PbDataAppController.getInstance.requestWithKey(key, params: params!, callback: { (data, error, property) -> Void in
                
                let logPre="UIViewController:pbLoadData:"+key+":"
                
                //输出错误信息
                if(error != nil)
                {
                    PbLog.error(logPre+error!.description)
                    self.delegate!.pbErrorForDataLoad(PbUIViewControllerErrorType.NetError, error: error!.description)
                    return
                }
                
                //解析控制器返回结果
                var conRes=data.objectForKey(PbDataAppController.KEY_RESPONSE) as! Dictionary<String,String>
                let netStatus=conRes[PbDataAppController.KEY_NETWORK]!
                let netSuccess=NSString(string:conRes[PbDataAppController.KEY_SUCCESS]!).boolValue
                
                //检查结果
                if(!netSuccess)
                {
                    if(PbDataAppController.getInstance.isNetworkConnected(netStatus))
                    {
                        PbLog.error(logPre+"未连接网络")
                        self.delegate!.pbErrorForDataLoad(PbUIViewControllerErrorType.NetNotConnected, error:"未连接网络")
                        return
                    }
                    
                    PbLog.error(logPre+"访问失败")
                    self.delegate!.pbErrorForDataLoad(PbUIViewControllerErrorType.NetFailed, error:"访问失败")
                    return
                }
                
                //处理数据
                let response: AnyObject?=self.delegate!.pbResolveFromResponse(data)
                //非增量获取数据处理
                if(updateMode != PbDataUpdateMode.NextPage)
                {
                    self.delegate!.pbDoUpdateForDataLoad(response,updateMode:updateMode,property:property)
                    self.pageNum=1
                }
                //增量类查询
                else
                {
                    self.delegate!.pbDoInsertForDataLoad(response,updateMode:updateMode,property:property)
                    self.pageNum++
                }
                
                //调用视图刷新方法
                self.delegate!.pbDoUIDisplayForDataLoad(response, updateMode: updateMode,property:property)
                
                //初次载入后自动更新
                if(updateMode==PbDataUpdateMode.First&&self.delegate!.pbAutoUpdateAfterFirstLoad()&&PbDataAppController.getInstance.isNetworkConnected())
                {
                    self.loadData(PbDataUpdateMode.Update)
                }
                
                //执行数据载入结束处理方法
                self.delegate!.pbDoEndForDataLoad(response, updateMode: updateMode,property:property)
                self.isDataLoading=false
                
            }, getMode: getMode, property: property)
        }
    }
}
