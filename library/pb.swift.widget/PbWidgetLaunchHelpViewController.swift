//
//  PbWidgetLaunchHelpViewController.swift
//  pb.swift.widget
//
//  Created by Maqiang on 15/9/3.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

public class PbWidgetLaunchHelpViewController:PbUICollectionViewController
{
    //pageControl:页码指示器
    let pageControl=PbUIAnimatedPageControl(frame:CGRectZero)
    //startButton:进入按钮
    let startButton=UIButton(frame:CGRectZero)
    
    //viewDidLoad:视图设置
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        
        //设置数据
        let array=self.imageArray()
        if(array != nil)
        {
            self.collectionData=NSMutableArray(capacity:array!.count)
            for(var i=0;i<array!.count;i++)
            {
                self.collectionData?.addObject(["image":array![i]])
            }
        }
        
        //视图初始化
        self.setup()
        
        //添加元素
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.startButton)
        
        //设置布局
        self.setCollectionViewLayout()
    }
    
    //pbSupport:设置网格控制器类型
    override func pbSupportActivityIndicator() -> PbUIActivityIndicator?{return nil}
    override func pbSupportHeaderRefresh() -> Bool{return false}
    override func pbSupportFooterLoad() -> Bool{return false}
    
    //pbCellClassForCollectionView:注册单元各类
    override func pbCellClassForCollectionView(indexPath: NSIndexPath, data: NSDictionary?) -> AnyClass?
    {
        return PbUICollectionViewCellForImage.self
    }
    
    //pbIdentifierForCollectionView:设置单元格复用标识
    override func pbIdentifierForCollectionView(indexPath: NSIndexPath, data: NSDictionary?) -> String
    {
        return "PbWidgetLaunchHelpView"
    }
    
    //pbSetDataForCollectionView:设置单元格显示
    override func pbSetDataForCollectionView(cell: AnyObject, data: NSDictionary?, photoRecord: PbDataPhotoRecord?, indexPath: NSIndexPath) -> AnyObject
    {
        let cell=cell as! PbUICollectionViewCellForImage
        
        cell.imageView.contentMode=UIViewContentMode.ScaleAspectFill
        cell.imageView.image=UIImage(named:(data?.objectForKey("image") as! String))
        
        return cell
    }
    
    //setup:视图初始化(覆盖此方法重设页码指示器显示样式，建议调用父类的setup方法)
    func setup()
    {
        //pageControl
        self.pageControl.bindScrollView=self.collectionView
        self.pageControl.pageCount=self.collectionData!.count
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.unSelectedColor=UIColor.pbSmokeWhiteColor()
        self.pageControl.selectedColor=UIColor.pbSkyBlueColor()
        self.pageControl.shouldShowProgressLine = true
        self.pageControl.indicatorStyle = PbUIAnimatedPageControlIndicatorStyle.GooeyCircle
        self.pageControl.indicatorSize = self.pageControlSize().height
        self.pageControl.swipeEnable = true
        self.pageControl.frame=CGRectMake(0, 0,self.pageControlSize().width,self.pageControlSize().height)
        
        //startButton
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.setTitle("进入应用",forState:.Normal)
        self.startButton.setTitleColor(UIColor.blackColor(),forState:.Normal)
        self.startButton.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor(), size: self.startButtonSize()), forState: UIControlState.Normal)
        self.startButton.titleLabel?.font=UIFont.systemFontOfSize(15)
        self.startButton.layer.cornerRadius=3
        self.startButton.clipsToBounds=true
        self.startButton.layer.opacity=0
        self.startButton.addTarget(self, action: Selector("startButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        //collectionView
        self.collectionView?.backgroundColor=UIColor.whiteColor()
        self.collectionView?.showsHorizontalScrollIndicator=false
        self.collectionView?.showsVerticalScrollIndicator=false
        self.collectionView?.scrollEnabled=true
        self.collectionView?.pagingEnabled=true
    }
    
    //imageArray:设置显示图的图片数组(覆盖此方法设置每页显示的图片)
    func imageArray() -> Array<String>?
    {
        return nil
    }
    
    //pageControlSize:设置分页指示器的大小(覆盖此方法重设页码指示器大小)
    func pageControlSize() -> CGSize
    {
        return CGSizeMake(80,15)
    }
    
    //startButtonSize:设置进入按钮的大小(覆盖此方法重设进入按钮大小)
    func startButtonSize() -> CGSize
    {
        return CGSizeMake(200,34)
    }
    
    //startButtonAction:设置进入按钮的点击事件(覆盖此方法重设点击事件)
    func startButtonAction(button:UIButton){}
    
    //setCollectionViewLayout:设置单元格布局
    private func setCollectionViewLayout()
    {
        //collectionViewLayout
        let layout=UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        layout.headerReferenceSize=CGSizeMake(0, 0)
        layout.footerReferenceSize=CGSizeMake(0, 0)
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection=UICollectionViewScrollDirection.Horizontal
        layout.itemSize=PbSystem.screenCurrentSize(true)
        self.collectionView?.setCollectionViewLayout(layout,animated: false)
        
        //pageControl+startButton
        let metrics=["width":self.pageControlSize().width,"height":self.pageControlSize().height,"btnWidth":self.startButtonSize().width,"btnHeight":self.startButtonSize().height,"margin":20]
        let views=["pageControl":self.pageControl,"startButton":self.startButton]
        //纵向
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[startButton(==btnHeight)]-margin-[pageControl(==height)]-margin-|", options:.AlignAllCenterX, metrics: metrics, views:views))
        //横向
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[pageControl(==width)]", options:.AlignAllBaseline, metrics: metrics, views:views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[startButton(==btnWidth)]", options:.AlignAllBaseline, metrics: metrics, views:views))
        //中心位置
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute:.CenterX, relatedBy:.Equal, toItem: self.pageControl,attribute:.CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute:.CenterX, relatedBy:.Equal, toItem: self.startButton,attribute:.CenterX, multiplier: 1, constant: 0))
    }
    
    //displayStartButton:显示进入按钮
    private func displayStartButton(show:Bool)
    {
        if(show)
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.startButton.layer.opacity=1
                }) { (finished) -> Void in
                    
            }
        }
        else
        {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.startButton.layer.opacity=0
                }) { (finished) -> Void in
                    
            }
        }
    }
    
    //scrollViewDidScroll:滚动时执行粘土动画
    override public func scrollViewDidScroll(scrollView: UIScrollView)
    {
        //Indicator动画
        self.pageControl.indicator.animateIndicator(scrollView, pageControl: self.pageControl)
        
        if (scrollView.dragging || scrollView.decelerating || scrollView.tracking)
        {
            //背景线条动画
            self.pageControl.pageControlLine().animateSelectedLineWithScrollView(scrollView)
        }
    }
    
    //scrollViewWillBeginDecelerating:将要开始滚动，重置指示器位置
    override public func scrollViewWillBeginDecelerating(scrollView: UIScrollView)
    {
        if(self.startButton.layer.opacity==1)
        {
            self.displayStartButton(false)
        }
        self.pageControl.indicator.restoreAnimation(1.0/Float(self.pageControl.pageCount))
    }
    
    //scrollViewDidEndDecelerating:停止滚动，记录最后滚动的位置
    override public func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        self.pageControl.indicator.lastContentOffset=scrollView.contentOffset.x
        self.pageControl.selectedPage=Int(Double(scrollView.contentOffset.x)/Double((self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width))
        if(self.pageControl.selectedPage == self.collectionData!.count-1)
        {
            self.displayStartButton(true)
        }
    }
}
