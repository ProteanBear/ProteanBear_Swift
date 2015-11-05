//
//  PbUITabViewController.swift
//  pb.swift.ui
//  tab分栏视图控制器
//  Created by Maqiang on 15/7/16.
//  Copyright (c) 2015年 Maqiang. All rights reserved.
//

import Foundation
import UIKit

//PbUITabMenuData:Tab栏使用的菜单栏数据记录
public class PbUITabMenuData
{
    var index:String?
    var indexId:Int=0
    var displayName:String=""
    var collectionCellClass:AnyClass?
    var targetController:AnyClass?
    
    init(index:String,displayName:String)
    {
        self.index=index
        self.displayName=displayName
        self.collectionCellClass=PbUITabMenuViewCell.self
    }
    init(indexId:Int,displayName:String)
    {
        self.indexId=indexId
        self.displayName=displayName
        self.collectionCellClass=PbUITabMenuViewCell.self
    }
    init(index:String,indexId:Int,displayName:String,targetController:AnyClass?)
    {
        self.index=index
        self.indexId=indexId
        self.displayName=displayName
        self.collectionCellClass=PbUITabMenuViewCell.self
        self.targetController=targetController
    }
    init(index:String,indexId:Int,displayName:String,collectionCellClass:AnyClass?,targetController:AnyClass?)
    {
        self.index=index
        self.indexId=indexId
        self.displayName=displayName
        self.collectionCellClass=collectionCellClass
        self.targetController=targetController
    }
}

//PbUITabMenuViewCell:Tab栏使用的菜单栏单个菜单视图
class PbUITabMenuViewCell:UICollectionViewCell
{
    //titleLabel:文字标签
    let titleLabel=UILabel()
    //menuData:菜单对应的数据
    var menuData:PbUITabMenuData?
    {
        didSet
        {
            titleLabel.text=menuData?.displayName
        }
    }
    
    //初始化方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    //布局完成后设置
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[titleLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["titleLabel":titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[titleLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["titleLabel":titleLabel]))
    }
    
    //初始化网格视图
    private func setup()
    {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font=UIFont.systemFontOfSize(13)
        titleLabel.textAlignment=NSTextAlignment.Center
        self.addSubview(titleLabel)
    }
}

//PbUITabMenuView:Tab栏使用的菜单栏视图
class PbUITabMenuView:UITableViewCell,UICollectionViewDataSource
{
    //collectionView:使用网格视图
    var collectionView:UICollectionView!
    //menuData:指定菜单数据
    var menuData:Array<PbUITabMenuData>?
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    //初始化方法
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    //布局完成后设置
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["collectionView":collectionView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["collectionView":collectionView]))
    }
    
    //初始化网格视图
    private func setup()
    {
        let layout=UICollectionViewFlowLayout()
        layout.scrollDirection=UICollectionViewScrollDirection.Horizontal
        
        collectionView=UICollectionView(frame:CGRectZero, collectionViewLayout: layout)
        collectionView.dataSource=self;
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor=UIColor.pbAlmondWhiteColor()
        collectionView.showsHorizontalScrollIndicator=false
        collectionView.showsVerticalScrollIndicator=false
        self.addSubview(collectionView)
    }
    
    /*-----------------------开始：实现UICollectionViewDataSource*/
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (self.menuData != nil) ? (self.menuData!.count) : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var result:UICollectionViewCell?
        
        if(self.menuData != nil)
        {
            let menu:PbUITabMenuData=self.menuData![indexPath.row]
            if(menu.collectionCellClass != nil)
            {
                self.collectionView.registerClass(menu.collectionCellClass, forCellWithReuseIdentifier:"PbUITabMenuViewCell")
                result=self.collectionView.dequeueReusableCellWithReuseIdentifier("PbUITabMenuViewCell", forIndexPath: indexPath)
                (result as! PbUITabMenuViewCell).menuData=menu
            }
        }
        
        if(result == nil)
        {
            result=UICollectionViewCell()
        }
        
        return result!
    }
    
    /*-----------------------结束：实现UICollectionViewDataSource*/
}

//PbUITabViewController:基础Tab视图控制器
class PbUITabViewController:PbUITableViewController
{
    //pbNormalHeightForRowAtIndexPath:返回正常单元格的高度
    override func pbNormalHeightForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat
    {
        var result:CGFloat=0;
        //菜单栏
        if(indexPath.section==0){result=CGFloat(PbSystem.sizeTopMenuBarHeight)}
        //内容栏
        if(indexPath.section==1){result=self.view.frame.size.height-CGFloat(PbSystem.sizeTopMenuBarHeight)}
        return result;
    }
    
    /*-----------------------开始：实现PbUITableViewControllerProtocol*/
    
    //pbResolveFromResponse:解析处理返回的数据
    override func pbResolveFromResponse(response:NSDictionary) -> AnyObject?
    {
        return nil
    }
    
    //pbDoUpdateForDataLoad:执行更新类相关返回后的处理
    override func pbDoUpdateForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbDoInsertForDataLoad:执行增量类相关返回后的处理
    override func pbDoInsertForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbAutoUpdateAfterFirstLoad:初次载入后是否立即更新
    override func pbAutoUpdateAfterFirstLoad() -> Bool
    {
        return false
    }
    
    //pbSupportHeaderRefresh:是否支持表格顶部刷新
    override func pbSupportHeaderRefresh() -> Bool
    {
        return false
    }
    
    //pbSupportFooterLoad:是否支持表格底部载入
    override func pbSupportFooterLoad() -> Bool
    {
        return false
    }
    
    //pbIdentifierForTableView:返回指定位置的单元格标识
    override func pbIdentifierForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> String
    {
        return (indexPath.section==0) ? "PbUITabMenuView" : "PbUITabContentView"
    }
    
    //pbInitCellForTableView:返回自定义的单元格对象
    override func pbInitCellForTableView(indexPath:NSIndexPath,data:NSDictionary?) -> AnyObject?
    {
        return nil
    }
    
    //pbSetDataForTableView:设置表格数据显示
    override func pbSetDataForTableView(cell:AnyObject,data:NSDictionary?,photoRecord:PbDataPhotoRecord?,indexPath:NSIndexPath) -> AnyObject
    {
        return cell
    }
    
    /*-----------------------结束：实现PbUITableViewControllerProtocol*/
    
    /*-----------------------开始：实现UITableViewDataSource*/
    
    //numberOfSectionsInTableView:返回当前表格的节数量
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return (self.tableData == nil) ? 0 : 2
    }
    
    //tableView:numberOfRowsInSection:返回列表数据的数据量
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.tableData == nil) ? 0 : 1
    }
    
    //tableView:cellForRowAtIndexPath:返回指定索引对应的列表项
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var result:UITableViewCell?
        
        //菜单栏
        if(indexPath.section==0 && indexPath.row==0)
        {
            result=(self.tableView.dequeueReusableCellWithIdentifier(self.pbIdentifierForTableView(indexPath, data: nil)))
            if(result == nil)
            {
                result=PbUITabMenuView(style: UITableViewCellStyle.Default, reuseIdentifier:self.pbIdentifierForTableView(indexPath, data: nil))
            }
            
            //设置菜单
            (result as! PbUITabMenuView).menuData=[
                PbUITabMenuData(indexId:1, displayName:"菜单1"),
                PbUITabMenuData(indexId:2, displayName:"菜单2"),
                PbUITabMenuData(indexId:3, displayName:"菜单3"),
                PbUITabMenuData(indexId:4, displayName:"菜单4"),
                PbUITabMenuData(indexId:5, displayName:"菜单5"),
                PbUITabMenuData(indexId:6, displayName:"菜单6"),
                PbUITabMenuData(indexId:7, displayName:"菜单7")
            ]
        }
        //内容栏
        if(indexPath.section==1 && indexPath.row==0)
        {
            
        }
            
        if(result == nil)
        {
            result=UITableViewCell()
        }
        
        return result!
    }
    
    /*-----------------------结束：实现UITableViewDataSource*/
}
