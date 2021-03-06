//
//  PbDataAdapter.swift
//  pb.swift.data
//  数据绑定器，增加新的委托协议，用于为视图控制器增加数据载入流程等方法
//  Created by Maqiang on 15/6/29.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

/**枚举类型，错误类型
 * netNotConnected:网络未连接
 * netFailed:网络连接失败
 * netError:网络错误或超时
 * serverError:服务端错误
 */
public enum PbUIViewControllerErrorType:Int
{
    case netNotConnected,netFailed,netError,serverError
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

/// 视图控制器数据绑定实现的协议
public protocol PbUIViewControllerProtocol
{
    /// 数据适配器初始化时调用
    /// - parameter delegate:协议代理类
    func pbDoInitForDataLoad(_ delegate:PbUIViewControllerProtocol?)
    
    /// 返回当前数据访问使用的链接标识
    func pbKeyForDataLoad() -> String?
    
    /// 返回当前数据访问使用的参数
    /// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
    func pbParamsForDataLoad(_ updateMode:PbDataUpdateMode) -> NSMutableDictionary?
    
    /// 返回当前数据访问使用的页码参数名称
    func pbPageKeyForDataLoad() -> String
    
    /// 设置数据请求回执附带属性
    /// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
    func pbPropertyForDataLoad(_ updateMode:PbDataUpdateMode) -> NSDictionary?
    
    /// 开始请求前处理
    /// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
    func pbWillRequestForDataLoad(_ updateMode:PbDataUpdateMode)
    
    /// 出现访问错误时调用
    /// - parameter type    :错误类型
    /// - parameter error   :错误信息
    func pbErrorForDataLoad(_ type:PbUIViewControllerErrorType,error:String)
    
    /// 解析处理返回的数据
    /// - parameter response:返回数据，已经解析为字典
    func pbResolveFromResponse(_ response:NSDictionary) -> AnyObject?
    
    /// 解析处理返回的数据
    /// - parameter response:返回数据，已经解析为字典
    /// - parameter updateMode:数据更新模式，包括第一次、更新和翻页
    func pbResolveFromResponse(_ response:NSDictionary,updateMode:PbDataUpdateMode) -> AnyObject?
    
    /// 执行更新类相关返回后的处理
    /// - parameter response    :返回数据，已经解析为字典
    /// - parameter updateMode  :数据更新模式，包括第一次、更新和翻页
    /// - parameter property    :回传属性
    func pbDoUpdateForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    
    /// 执行增量类相关返回后的处理
    /// - parameter response    :返回数据，已经解析为字典
    /// - parameter updateMode  :数据更新模式，包括第一次、更新和翻页
    /// - parameter property    :回传属性
    func pbDoInsertForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    
    /// 执行相关返回后的视图更新处理
    /// - parameter response    :返回数据，已经解析为字典
    /// - parameter updateMode  :数据更新模式，包括第一次、更新和翻页
    /// - parameter property    :回传属性
    func pbDoUIDisplayForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    
    /// 执行数据载入结束后的处理
    /// - parameter response    :返回数据，已经解析为字典
    /// - parameter updateMode  :数据更新模式，包括第一次、更新和翻页
    /// - parameter property    :回传属性
    func pbDoEndForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    
    /// 初次载入后是否立即更新
    func pbAutoUpdateAfterFirstLoad() -> Bool
    
    /// 支持载入显示器
    func pbSupportActivityIndicator() -> PbUIActivityIndicator?
}

/// 表格视图控制器数据绑定实现的协议
public protocol PbUITableViewControllerProtocol:PbUIViewControllerProtocol
{
    /// 是否支持表格顶部刷新
    func pbSupportHeaderRefresh() -> Bool
    
    /// 返回表格顶部刷新视图类型
    func pbSupportHeaderRefreshType() -> PbUIViewType
    
    /// 表格顶部刷新的主题颜色（tiniColor）
    func pbSupportHeaderRefreshColor() -> UIColor?
    
    /// 是否支持表格底部载入
    func pbSupportFooterLoad() -> Bool
    
    /// 返回表格底部载入类型
    func pbSupportFooterLoadType() -> PbUIViewType
    
    /// 表格底部载入主题颜色（tiniColor）
    func pbSupportFooterLoadColor() -> UIColor?
    
    /// 获取指定单元格位置的数据
    /// - parameter indexPath:单元格位置索引
    func pbResolveDataInIndexPath(_ indexPath:IndexPath) -> AnyObject?
    
    /// 返回指定位置的单元格标识
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    func pbIdentifierForTableView(_ indexPath:IndexPath,data:AnyObject?) -> String
    
    /// 返回指定位置单元格使用的资源文件
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    func pbNibNameForTableView(_ indexPath:IndexPath,data:AnyObject?) -> String?
    
    /// 返回指定位置单元格使用的资源文件
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    func pbNibIndexForTableView(_ indexPath:IndexPath,data:AnyObject?) -> Int
    
    /// 返回自定义的单元格对象
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    func pbInitCellForTableView(_ indexPath:IndexPath,data:AnyObject?) -> AnyObject?
    
    /// 设置表格数据显示
    /// - parameter cell        :单元格对象
    /// - parameter data        :位置对应的数据
    /// - parameter photoRecord :位置对应的图片数据信息
    /// - parameter indexPath   :单元格位置索引
    func pbSetDataForTableView(_ cell:AnyObject,data:AnyObject?,photoRecord:PbDataPhotoRecord?,indexPath:IndexPath) -> AnyObject
}

/// 网管视图控制器数据绑定实现的协议
public protocol PbUICollectionViewControllerProtocol:PbUIViewControllerProtocol
{
    /// 是否支持表格顶部刷新
    func pbSupportHeaderRefresh() -> Bool
    
    /// 表格顶部刷新的主题颜色（tiniColor）
    func pbSupportHeaderRefreshColor() -> UIColor?
    
    /// 是否支持表格底部载入
    func pbSupportFooterLoad() -> Bool
    
    /// 返回表格底部载入类型
    func pbSupportFooterLoadType() -> PbUIViewType
    
    /// 表格底部载入主题颜色（tiniColor）
    func pbSupportFooterLoadColor() -> UIColor?
    
    /// 获取指定单元格位置的数据
    /// - parameter indexPath   :单元格位置索引
    func pbResolveDataInIndexPath(_ indexPath:IndexPath) -> AnyObject?
    
    /// 返回指定位置的单元格标识
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    func pbIdentifierForCollectionView(_ indexPath:IndexPath,data:AnyObject?) -> String
    
    /// 返回指定位置单元格使用的资源文件
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    func pbNibNameForCollectionView(_ indexPath:IndexPath,data:AnyObject?) -> String?
    
    /// 返回指定位置单元格的类
    /// - parameter indexPath   :单元格位置索引
    /// - parameter data        :位置对应的数据
    func pbCellClassForCollectionView(_ indexPath:IndexPath,data:AnyObject?) -> AnyClass?
    
    /// 设置网格数据显示
    /// - parameter cell        :单元格对象
    /// - parameter data        :位置对应的数据
    /// - parameter photoRecord :位置对应的图片数据信息
    /// - parameter indexPath   :单元格位置索引
    func pbSetDataForCollectionView(_ cell:AnyObject,data:AnyObject?,photoRecord:PbDataPhotoRecord?,indexPath:IndexPath) -> AnyObject
}

open class PbDataAdapter
{
    /// 数据处理方法绑定委托
    var delegate:PbUIViewControllerProtocol?
    var indicator:PbUIActivityIndicator?
    
    /// 记录当前的列表访问页码
    lazy var pageNum=1
    /// 下一页是否为空
    open lazy var nextIsNull=false
    /// 是否初始化载入
    open lazy var isInitLoad=true
    /// 是否在数据载入中
    open lazy var isDataLoading=false
    
    /// 初始化方法
    public init(delegate:PbUIViewControllerProtocol?)
    {
        self.delegate=delegate
        self.delegate?.pbDoInitForDataLoad(delegate)
        
        //初始化载入指示器
        self.indicator=self.delegate?.pbSupportActivityIndicator()
    }
    
    /// 加载网络数据
    open func loadData(_ updateMode:PbDataUpdateMode)
    {
        if(self.delegate == nil){return}
        
        //判断获取模式
        var getMode=PbDataGetMode.fromLocalOrNet
        var toPage=self.pageNum
        if(updateMode == PbDataUpdateMode.first)
        {
            toPage=1
            getMode=PbDataGetMode.fromLocal
            self.nextIsNull=false
            self.isInitLoad=true
        }
        else if(updateMode == PbDataUpdateMode.update)
        {
            toPage=1
            getMode=PbDataGetMode.fromNet
            self.nextIsNull=false
        }
        else if(updateMode == PbDataUpdateMode.nextPage)
        {
            toPage += 1
            getMode=PbDataGetMode.fromLocalOrNet
        }
        else
        {
            return
        }
        
        //指定标识则执行数据获取流程
        if let key = self.delegate!.pbKeyForDataLoad()
        {
            //如果为第一次载入，显示载入指示器
            if(updateMode == PbDataUpdateMode.first)
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
            params?.setObject(toPage,forKey:self.delegate!.pbPageKeyForDataLoad() as NSCopying)
            //回执附带属性
            let property=self.delegate!.pbPropertyForDataLoad(updateMode)
            
            //载入数据
            self.delegate!.pbWillRequestForDataLoad(updateMode)
            PbDataAppController.instance.request(key, params: params!, callback: { (data, error, property) -> Void in
                
                let logPre="UIViewController:pbLoadData:"+key+":"
                
                //输出错误信息
                if(error != nil)
                {
                    PbLog.error(logPre+(error?.description)!)
                    self.delegate!.pbErrorForDataLoad(PbUIViewControllerErrorType.netError, error: (error?.description)!)
                    return
                }
                
                //解析控制器返回结果
                var conRes=data?.object(forKey: PbDataAppController.KEY_RESPONSE) as! Dictionary<String,String>
                let netStatus=conRes[PbDataAppController.KEY_NETWORK]!
                let netSuccess=NSString(string:conRes[PbDataAppController.KEY_SUCCESS]!).boolValue
                
                //检查结果
                if(!netSuccess)
                {
                    if(PbDataAppController.instance.isNetworkConnected(netStatus))
                    {
                        PbLog.error(logPre+"未连接网络")
                        self.delegate!.pbErrorForDataLoad(PbUIViewControllerErrorType.netNotConnected, error:"未连接网络")
                        return
                    }
                    
                    PbLog.error(logPre+"访问失败")
                    self.delegate!.pbErrorForDataLoad(PbUIViewControllerErrorType.netFailed, error:"访问失败")
                    return
                }
                
                //处理数据
                var response: AnyObject?=self.delegate!.pbResolveFromResponse(data!)
                if(response == nil)
                {
                    response=self.delegate?.pbResolveFromResponse(data!, updateMode: updateMode)
                }
                if(response == nil)
                {
                    PbLog.error(logPre+"返回数据为空")
                    self.delegate!.pbErrorForDataLoad(PbUIViewControllerErrorType.netFailed, error:"返回数据为空")
                }
                //非增量获取数据处理
                if(updateMode != PbDataUpdateMode.nextPage)
                {
                    self.delegate!.pbDoUpdateForDataLoad(response,updateMode:updateMode,property:property)
                    self.pageNum=1
                }
                //增量类查询
                else
                {
                    self.delegate!.pbDoInsertForDataLoad(response,updateMode:updateMode,property:property)
                    self.pageNum+=1
                }
                
                //调用视图刷新方法
                self.delegate!.pbDoUIDisplayForDataLoad(response, updateMode: updateMode,property:property)
                
                //初次载入后自动更新
                if(updateMode==PbDataUpdateMode.first&&self.delegate!.pbAutoUpdateAfterFirstLoad()&&PbDataAppController.instance.isNetworkConnected())
                {
                    self.loadData(PbDataUpdateMode.update)
                }
                
                //执行数据载入结束处理方法
                self.delegate!.pbDoEndForDataLoad(response, updateMode: updateMode,property:property)
                self.isDataLoading=false
                
            }, getMode: getMode, property: property)
        }
    }
}
