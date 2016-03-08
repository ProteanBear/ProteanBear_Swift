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
    public var index:String?
    public var indexId:Int=0
    public var displayName:String=""
    public var collectionCellClass:AnyClass?
    public var targetController:AnyClass?
    
    public init(index:String,displayName:String)
    {
        self.index=index
        self.displayName=displayName
        self.collectionCellClass=PbUITabMenuViewCell.self
    }
    public init(indexId:Int,displayName:String)
    {
        self.indexId=indexId
        self.displayName=displayName
        self.collectionCellClass=PbUITabMenuViewCell.self
    }
    public init(index:String,indexId:Int,displayName:String,targetController:AnyClass?)
    {
        self.index=index
        self.indexId=indexId
        self.displayName=displayName
        self.collectionCellClass=PbUITabMenuViewCell.self
        self.targetController=targetController
    }
    public init(index:String,indexId:Int,displayName:String,collectionCellClass:AnyClass?,targetController:AnyClass?)
    {
        self.index=index
        self.indexId=indexId
        self.displayName=displayName
        self.collectionCellClass=collectionCellClass
        self.targetController=targetController
    }
}

//PbUITabMenuViewCell:Tab栏使用的菜单栏单个菜单视图
public class PbUITabMenuViewCell:UICollectionViewCell
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
    //selected:选中状态
    override public var selected: Bool{
        didSet{
            self.titleLabel.textColor=(self.selected) ? UIColor.darkGrayColor():UIColor.lightGrayColor()
        }
    }
    
    //初始化方法
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    //布局完成后设置
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[titleLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["titleLabel":titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[titleLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["titleLabel":titleLabel]))
    }
    
    //初始化网格视图
    private func setup()
    {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font=UIFont.systemFontOfSize(16)
        titleLabel.textColor=UIColor.lightGrayColor()
        titleLabel.textAlignment=NSTextAlignment.Center
        self.addSubview(titleLabel)
    }
}

//PbUITabMenuView:Tab栏使用的菜单栏视图
public class PbUITabMenuView:UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate
{
    //maxNumPer:最多一屏显示数量
    public var maxNumPer=4
    //collectionView:使用网格视图
    var collectionView:UICollectionView!
    //click:点击选项卡处理
    public var click:((data:PbUITabMenuData) -> Void)?
    //menuData:指定菜单数据
    public var menuData:Array<PbUITabMenuData>?
    {
        didSet
        {
            //根据菜单数量进行设置
            self.collectionView.setCollectionViewLayout(self.collectionViewLayout(), animated: true)
            
            collectionView.reloadData()
            self.collectionView.selectItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.Right)
        }
    }
    
    //初始化方法
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    //布局完成后设置
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["collectionView":collectionView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["collectionView":collectionView]))
    }
    
    //绘制单元格底部的线
    public override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        
        let width:CGFloat=0.1
        CGContextSetLineWidth(context,width)
        CGContextSetStrokeColorWithColor(context,UIColor.blackColor().CGColor)
        
        CGContextMoveToPoint(context,0,self.frame.size.height-width)
        CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height-width)
        
        CGContextStrokePath(context)
        
        self.collectionView.setCollectionViewLayout(self.collectionViewLayout(), animated: true)
    }
    
    //选择指定的Tab栏
    public func selectMenu(index:Int)
    {
        self.collectionView.selectItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.Right)
    }
    
    //初始化网格视图
    private func setup()
    {
        self.backgroundColor=UIColor.clearColor()
        
        collectionView=UICollectionView(frame:CGRectZero, collectionViewLayout: self.collectionViewLayout())
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor=UIColor.clearColor()
        collectionView.showsHorizontalScrollIndicator=false
        collectionView.showsVerticalScrollIndicator=false
        self.addSubview(collectionView)
    }
    
    //获取布局设置
    private func collectionViewLayout() -> UICollectionViewFlowLayout
    {
        let layout=UICollectionViewFlowLayout()
        layout.scrollDirection=UICollectionViewScrollDirection.Horizontal
        layout.sectionInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        
        if(self.menuData != nil)
        {
            layout.itemSize=CGSize(width:PbSystem.screenWidth(true)/CGFloat(min(self.maxNumPer,self.menuData!.count)),height:CGFloat(PbSystem.sizeTopMenuBarHeight))
        }
        
        return layout
    }
    
    /*-----------------------开始：实现UICollectionViewDataSource*/
    //单元格数量
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (self.menuData != nil) ? (self.menuData!.count) : 0
    }
    
    //单元格对象
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
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
    
    /*-----------------------开始：实现UICollectionViewDelegate*/
    //选中单元格时处理
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if(self.click != nil)
        {
            self.click!(data: self.menuData![indexPath.row])
        }
    }
    /*-----------------------结束：实现UICollectionViewDelegate*/
}

//PbUITabViewController:基础Tab视图控制器
public class PbUITabViewController:PbUITableViewController
{
    //pbNormalHeightForRowAtIndexPath:返回正常单元格的高度
    override public func pbNormalHeightForRowAtIndexPath(tableView: UITableView, indexPath: NSIndexPath) -> CGFloat
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
    override public func pbResolveFromResponse(response:NSDictionary) -> AnyObject?
    {
        return nil
    }
    
    //pbDoUpdateForDataLoad:执行更新类相关返回后的处理
    override public func pbDoUpdateForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbDoInsertForDataLoad:执行增量类相关返回后的处理
    override public func pbDoInsertForDataLoad(response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbAutoUpdateAfterFirstLoad:初次载入后是否立即更新
    override public func pbAutoUpdateAfterFirstLoad() -> Bool
    {
        return false
    }
    
    //pbSupportHeaderRefresh:是否支持表格顶部刷新
    override public func pbSupportHeaderRefresh() -> Bool
    {
        return false
    }
    
    //pbSupportFooterLoad:是否支持表格底部载入
    override public func pbSupportFooterLoad() -> Bool
    {
        return false
    }
    
    //pbIdentifierForTableView:返回指定位置的单元格标识
    override public func pbIdentifierForTableView(indexPath:NSIndexPath,data:AnyObject?) -> String
    {
        return (indexPath.section==0) ? "PbUITabMenuView" : "PbUITabContentView"
    }
    
    //pbInitCellForTableView:返回自定义的单元格对象
    override public func pbInitCellForTableView(indexPath:NSIndexPath,data:AnyObject?) -> AnyObject?
    {
        return nil
    }
    
    //pbSetDataForTableView:设置表格数据显示
    override public func pbSetDataForTableView(cell:AnyObject,data:AnyObject?,photoRecord:PbDataPhotoRecord?,indexPath:NSIndexPath) -> AnyObject
    {
        return cell
    }
    
    /*-----------------------结束：实现PbUITableViewControllerProtocol*/
    
    /*-----------------------开始：实现UITableViewDataSource*/
    
    //numberOfSectionsInTableView:返回当前表格的节数量
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return (self.tableData == nil) ? 0 : 2
    }
    
    //tableView:numberOfRowsInSection:返回列表数据的数据量
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.tableData == nil) ? 0 : 1
    }
    
    //tableView:cellForRowAtIndexPath:返回指定索引对应的列表项
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
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
