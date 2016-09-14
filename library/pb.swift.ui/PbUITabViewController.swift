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
open class PbUITabMenuData
{
    open var index:String?
    open var indexId:Int=0
    open var displayName:String=""
    open var collectionCellClass:AnyClass?
    open var targetController:AnyClass?
    
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
open class PbUITabMenuViewCell:UICollectionViewCell
{
    //titleLabel:文字标签
    open let titleLabel=UILabel()
    //menuData:菜单对应的数据
    var menuData:PbUITabMenuData?
    {
        didSet
        {
            titleLabel.text=menuData?.displayName
        }
    }
    //selected:选中状态
    override open var isSelected: Bool{
        didSet{
            self.titleLabel.textColor=(self.isSelected) ? self.tintColor:UIColor.lightGray
        }
    }
    //选中颜色
    override open var tintColor: UIColor!{
        didSet{
            self.titleLabel.textColor=(self.isSelected) ? self.tintColor:UIColor.lightGray
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
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[titleLabel]-0-|", options: NSLayoutFormatOptions.alignAllBaseline, metrics: nil, views: ["titleLabel":titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[titleLabel]-0-|", options: NSLayoutFormatOptions.alignAllBaseline, metrics: nil, views: ["titleLabel":titleLabel]))
    }
    
    //初始化网格视图
    fileprivate func setup()
    {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font=UIFont.systemFont(ofSize: 16)
        titleLabel.textColor=UIColor.lightGray
        titleLabel.textAlignment=NSTextAlignment.center
        self.addSubview(titleLabel)
    }
}

//PbUITabMenuView:Tab栏使用的菜单栏视图
open class PbUITabMenuView:UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate
{
    //maxNumPer:最多一屏显示数量
    open var maxNumPer=5
    //textColorSelected:选中时的颜色
    open var textColorSelected=UIColor.darkGray
    //textFont:字体设置
    open var textFont=UIFont.systemFont(ofSize: 16)
    //collectionView:使用网格视图
    open var collectionView:UICollectionView!
    //click:点击选项卡处理
    open var click:((_ data:PbUITabMenuData) -> Void)?
    //menuData:指定菜单数据
    open var menuData:Array<PbUITabMenuData>?
    {
        didSet
        {
            //根据菜单数量进行设置
            self.collectionView.setCollectionViewLayout(self.collectionViewLayout(), animated: true)
            
            collectionView.reloadData()
            self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.right)
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
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.alignAllBaseline, metrics: nil, views: ["collectionView":collectionView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.alignAllBaseline, metrics: nil, views: ["collectionView":collectionView]))
    }
    
    //绘制单元格底部的线
    open override func draw(_ rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        
        let width:CGFloat=0.1
        context?.setLineWidth(width)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        context?.move(to: CGPoint(x: 0, y: self.frame.size.height-width))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height-width))
        
        context?.strokePath()
        
        self.collectionView.setCollectionViewLayout(self.collectionViewLayout(), animated: true)
    }
    
    //选择指定的Tab栏
    open func selectMenu(_ index:Int)
    {
        self.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.right)
    }
    
    //初始化网格视图
    fileprivate func setup()
    {
        self.backgroundColor=UIColor.clear
        
        collectionView=UICollectionView(frame:CGRect.zero, collectionViewLayout: self.collectionViewLayout())
        collectionView.dataSource=self
        collectionView.delegate=self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor=UIColor.clear
        collectionView.showsHorizontalScrollIndicator=false
        collectionView.showsVerticalScrollIndicator=false
        self.addSubview(collectionView)
    }
    
    //获取布局设置
    open func collectionViewLayout() -> UICollectionViewFlowLayout
    {
        let layout=UICollectionViewFlowLayout()
        layout.scrollDirection=UICollectionViewScrollDirection.horizontal
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
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return (self.menuData != nil) ? (self.menuData!.count) : 0
    }
    
    //单元格对象
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var result:UICollectionViewCell?
        
        if(self.menuData != nil)
        {
            let menu:PbUITabMenuData=self.menuData![(indexPath as NSIndexPath).row]
            if(menu.collectionCellClass != nil)
            {
                self.collectionView.register(menu.collectionCellClass, forCellWithReuseIdentifier:"PbUITabMenuViewCell")
                result=self.collectionView.dequeueReusableCell(withReuseIdentifier: "PbUITabMenuViewCell", for: indexPath)
                (result as! PbUITabMenuViewCell).tintColor=self.textColorSelected
                (result as! PbUITabMenuViewCell).titleLabel.font=self.textFont
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
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(self.click != nil)
        {
            self.click!(self.menuData![(indexPath as NSIndexPath).row])
        }
    }
    /*-----------------------结束：实现UICollectionViewDelegate*/
}

//PbUITabViewController:基础Tab视图控制器
open class PbUITabViewController:PbUITableViewController
{
    //pbNormalHeightForRowAtIndexPath:返回正常单元格的高度
    override open func pbNormalHeightForRowAtIndexPath(_ tableView: UITableView, indexPath: IndexPath) -> CGFloat
    {
        var result:CGFloat=0;
        //菜单栏
        if((indexPath as NSIndexPath).section==0){result=CGFloat(PbSystem.sizeTopMenuBarHeight)}
        //内容栏
        if((indexPath as NSIndexPath).section==1){result=self.view.frame.size.height-CGFloat(PbSystem.sizeTopMenuBarHeight)}
        return result;
    }
    
    /*-----------------------开始：实现PbUITableViewControllerProtocol*/
    
    //pbResolveFromResponse:解析处理返回的数据
    override open func pbResolveFromResponse(_ response:NSDictionary) -> AnyObject?
    {
        return nil
    }
    
    //pbDoUpdateForDataLoad:执行更新类相关返回后的处理
    override open func pbDoUpdateForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbDoInsertForDataLoad:执行增量类相关返回后的处理
    override open func pbDoInsertForDataLoad(_ response:AnyObject?,updateMode:PbDataUpdateMode,property:NSDictionary?)
    {
    }
    
    //pbAutoUpdateAfterFirstLoad:初次载入后是否立即更新
    override open func pbAutoUpdateAfterFirstLoad() -> Bool
    {
        return false
    }
    
    //pbSupportHeaderRefresh:是否支持表格顶部刷新
    override open func pbSupportHeaderRefresh() -> Bool
    {
        return false
    }
    
    //pbSupportFooterLoad:是否支持表格底部载入
    override open func pbSupportFooterLoad() -> Bool
    {
        return false
    }
    
    //pbIdentifierForTableView:返回指定位置的单元格标识
    override open func pbIdentifierForTableView(_ indexPath:IndexPath,data:AnyObject?) -> String
    {
        return ((indexPath as NSIndexPath).section==0) ? "PbUITabMenuView" : "PbUITabContentView"
    }
    
    //pbInitCellForTableView:返回自定义的单元格对象
    override open func pbInitCellForTableView(_ indexPath:IndexPath,data:AnyObject?) -> AnyObject?
    {
        return nil
    }
    
    //pbSetDataForTableView:设置表格数据显示
    override open func pbSetDataForTableView(_ cell:AnyObject,data:AnyObject?,photoRecord:PbDataPhotoRecord?,indexPath:IndexPath) -> AnyObject
    {
        return cell
    }
    
    /*-----------------------结束：实现PbUITableViewControllerProtocol*/
    
    /*-----------------------开始：实现UITableViewDataSource*/
    
    //numberOfSectionsInTableView:返回当前表格的节数量
    override open func numberOfSections(in tableView: UITableView) -> Int
    {
        return (self.tableData == nil) ? 0 : 2
    }
    
    //tableView:numberOfRowsInSection:返回列表数据的数据量
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.tableData == nil) ? 0 : 1
    }
    
    //tableView:cellForRowAtIndexPath:返回指定索引对应的列表项
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var result:UITableViewCell?
        
        //菜单栏
        if((indexPath as NSIndexPath).section==0 && (indexPath as NSIndexPath).row==0)
        {
            result=(self.tableView.dequeueReusableCell(withIdentifier: self.pbIdentifierForTableView(indexPath, data: nil)))
            if(result == nil)
            {
                result=PbUITabMenuView(style: UITableViewCellStyle.default, reuseIdentifier:self.pbIdentifierForTableView(indexPath, data: nil))
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
        if((indexPath as NSIndexPath).section==1 && (indexPath as NSIndexPath).row==0)
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
