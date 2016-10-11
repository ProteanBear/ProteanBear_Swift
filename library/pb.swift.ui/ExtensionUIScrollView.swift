//
//  ExtensionUIScrollView.swift
//  pb.swift.ui
//  扩展滚动视图，增加刷新组件
//  Created by Maqiang on 15/7/8.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView
{
    //pbAddUIRefreshViewToHeader:增加顶部下拉刷新视图
    public func pbAddUIRefreshViewToHeader(_ callback:(() -> Void)!)
    {
        let headerView=PbUIRefreshHeaderView(frame:CGRect(x: 0,y: 0,width: PbSystem.screenCurrentWidth,height: CGFloat(PbSystem.sizeUpdateViewHeight)))
        headerView.beginRefreshingCallback=callback
        headerView.state=PbUIRefreshState.normal
        self.addSubview(headerView)
    }
    
    //pbAddUIRefreshViewToHeader:增加顶部下拉刷新视图
    public func pbAddUIRefreshViewToHeader(_ callback:(() -> Void)!,delegate:PbUIRefreshConfigProtocol)
    {
        let headerView=PbUIRefreshHeaderView(frame:CGRect(x: 0, y: 0,width: PbSystem.screenCurrentWidth,height: CGFloat(PbSystem.sizeUpdateViewHeight)),config:delegate)
        headerView.beginRefreshingCallback=callback
        headerView.state=PbUIRefreshState.normal
        self.addSubview(headerView)
    }
    
    //pbRemoveUIRefreshViewFromHeader:删除顶部下拉刷新视图
    public func pbRemoveUIRefreshViewFromHeader()
    {
        for view : AnyObject in self.subviews
        {
            if view is PbUIRefreshHeaderView
            {
                view.removeFromSuperview()
            }
        }
    }
    
    //pbUIRefreshHeaderBegin:开始载入
    public func pbUIRefreshHeaderBegin()
    {
        for object : AnyObject in self.subviews
        {
            if object is PbUIRefreshHeaderView
            {
                object.beginRefreshing()
            }
        }
    }
    
    //pbUIRefreshHeaderEnd:停止载入
    public func pbUIRefreshHeaderEnd()
    {
        for object : AnyObject in self.subviews
        {
            if object is PbUIRefreshHeaderView
            {
                object.endRefreshing()
            }
        }
    }
    
    //pbUIRefreshHeaderSetUpdateTime:停止载入
    public func pbUIRefreshHeaderSetUpdateTime(_ date:Date)
    {
        for object : AnyObject in self.subviews
        {
            if object is PbUIRefreshHeaderView
            {
                (object as! PbUIRefreshHeaderView).arrowView.isHidden=false
                (object as! PbUIRefreshHeaderView).lastUpdateTime=date
                (object as! PbUIRefreshHeaderView).updateTimeLabel?.text=String.date(date, format: "yyyy年MM月dd日 HH:mm")
            }
        }
    }
    
//    //pbAddUIRefreshViewToFooter:增加底部上拉加载视图
//    func pbAddUIRefreshViewToFooter(callback:(() -> Void)!)
//    {
//        let footerView=PbUIRefreshFooterView(frame:CGRectMake(0,0,PbSystem.screenCurrentWidth(),CGFloat(PbSystem.sizeUpdateViewHeight)))
//        footerView.beginRefreshingCallback=callback
//        //footerView.state=PbUIRefreshState.Normal
//        self.addSubview(footerView)
//    }
//    
//    //pbAddUIRefreshViewToFooter:增加底部上拉加载视图
//    func pbAddUIRefreshViewToFooter(callback:(() -> Void)!,delegate:PbUIRefreshConfigProtocol)
//    {
//        let footerView=PbUIRefreshFooterView(frame:CGRectMake(0, 0,PbSystem.screenCurrentWidth(),CGFloat(PbSystem.sizeUpdateViewHeight)),config:delegate)
//        footerView.beginRefreshingCallback=callback
//        //footerView.state=PbUIRefreshState.Normal
//        self.addSubview(footerView)
//    }
//    
//    //pbRemoveUIRefreshViewFromFooter:删除底部上拉加载视图
//    func pbRemoveUIRefreshViewFromFooter()
//    {
//        for view : AnyObject in self.subviews
//        {
//            if view is PbUIRefreshFooterView
//            {
//                view.removeFromSuperview()
//            }
//        }
//    }
//    
//    //pbUIRefreshFooterBegin:开始载入
//    func pbUIRefreshFooterBegin()
//    {
//        for object : AnyObject in self.subviews
//        {
//            if object is PbUIRefreshFooterView
//            {
//                object.beginRefreshing()
//            }
//        }
//    }
//    
//    //pbUIRefreshFooterEnd:停止载入
//    func pbUIRefreshFooterEnd()
//    {
//        for object : AnyObject in self.subviews
//        {
//            if object is PbUIRefreshFooterView
//            {
//                object.endRefreshing()
//            }
//        }
//    }
}
