//
//  PbWidgetLaunchHelpViewController.swift
//  pb.swift.widget
//
//  Created by Maqiang on 15/9/3.
//  Copyright (c) 2015年 ProteanBear. All rights reserved.
//

import Foundation
import UIKit

open class PbWidgetLaunchHelpViewController:PbUICollectionViewController
{
    //pageControl:页码指示器
    let pageControl=PbUIAnimatedPageControl(frame:CGRect.zero)
    //startButton:进入按钮
    let startButton=UIButton(frame:CGRect.zero)
    
    //viewDidLoad:视图设置
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        //设置数据
        let array=self.imageArray()
        if(array != nil)
        {
            self.collectionData=NSMutableArray(capacity:array!.count)
            for i in 0 ..< array!.count 
            {
                self.collectionData?.add(["image":array![i]])
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
    override open func pbSupportActivityIndicator() -> PbUIActivityIndicator?{return nil}
    override open func pbSupportHeaderRefresh() -> Bool{return false}
    override open func pbSupportFooterLoad() -> Bool{return false}
    
    //pbCellClassForCollectionView:注册单元各类
    override open func pbCellClassForCollectionView(_ indexPath: IndexPath, data: AnyObject?) -> AnyClass?
    {
        return PbUICollectionViewCellForImage.self
    }
    
    //pbIdentifierForCollectionView:设置单元格复用标识
    override open func pbIdentifierForCollectionView(_ indexPath: IndexPath, data: AnyObject?) -> String
    {
        return "PbWidgetLaunchHelpView"
    }
    
    //pbSetDataForCollectionView:设置单元格显示
    override open func pbSetDataForCollectionView(_ cell: AnyObject, data: AnyObject?, photoRecord: PbDataPhotoRecord?, indexPath: IndexPath) -> AnyObject
    {
        let cell=cell as! PbUICollectionViewCellForImage
        
        cell.imageView.contentMode=UIViewContentMode.scaleAspectFill
        cell.imageView.image=UIImage(named:(data?.object(forKey: "image") as! String))
        
        return cell
    }
    
    //setup:视图初始化(覆盖此方法重设页码指示器显示样式，建议调用父类的setup方法)
    func setup()
    {
        //pageControl
        self.pageControl.bindScrollView=self.collectionView
        self.pageControl.pageCount=self.collectionData!.count
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.unSelectedColor=UIColor.pbSmokeWhite
        self.pageControl.selectedColor=UIColor.pbSkyBlue
        self.pageControl.shouldShowProgressLine = true
        self.pageControl.indicatorStyle = PbUIAnimatedPageControlIndicatorStyle.gooeyCircle
        self.pageControl.indicatorSize = self.pageControlSize().height
        self.pageControl.swipeEnable = true
        self.pageControl.frame=CGRect(x: 0, y: 0,width: self.pageControlSize().width,height: self.pageControlSize().height)
        
        //startButton
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.setTitle("进入应用",for:UIControlState())
        self.startButton.setTitleColor(UIColor.black,for:UIControlState())
        self.startButton.setBackgroundImage(UIImage.pbGenerateBy(UIColor.white, size: self.startButtonSize()), for: UIControlState())
        self.startButton.titleLabel?.font=UIFont.systemFont(ofSize: 15)
        self.startButton.layer.cornerRadius=3
        self.startButton.clipsToBounds=true
        self.startButton.layer.opacity=0
        self.startButton.addTarget(self, action: #selector(PbWidgetLaunchHelpViewController.startButtonAction(_:)), for: UIControlEvents.touchUpInside)
        
        //collectionView
        self.collectionView?.backgroundColor=UIColor.white
        self.collectionView?.showsHorizontalScrollIndicator=false
        self.collectionView?.showsVerticalScrollIndicator=false
        self.collectionView?.isScrollEnabled=true
        self.collectionView?.isPagingEnabled=true
    }
    
    //imageArray:设置显示图的图片数组(覆盖此方法设置每页显示的图片)
    func imageArray() -> Array<String>?
    {
        return nil
    }
    
    //pageControlSize:设置分页指示器的大小(覆盖此方法重设页码指示器大小)
    func pageControlSize() -> CGSize
    {
        return CGSize(width: 80,height: 15)
    }
    
    //startButtonSize:设置进入按钮的大小(覆盖此方法重设进入按钮大小)
    func startButtonSize() -> CGSize
    {
        return CGSize(width: 200,height: 34)
    }
    
    //startButtonAction:设置进入按钮的点击事件(覆盖此方法重设点击事件)
    func startButtonAction(_ button:UIButton){}
    
    //setCollectionViewLayout:设置单元格布局
    fileprivate func setCollectionViewLayout()
    {
        //collectionViewLayout
        let layout=UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        layout.headerReferenceSize=CGSize(width: 0, height: 0)
        layout.footerReferenceSize=CGSize(width: 0, height: 0)
        layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection=UICollectionViewScrollDirection.horizontal
        layout.itemSize=PbSystem.screenCurrentSize
        self.collectionView?.setCollectionViewLayout(layout,animated: false)
        
        //pageControl+startButton
        let metrics=["width":self.pageControlSize().width,"height":self.pageControlSize().height,"btnWidth":self.startButtonSize().width,"btnHeight":self.startButtonSize().height,"margin":20]
        let views=["pageControl":self.pageControl,"startButton":self.startButton]
        //纵向
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[startButton(==btnHeight)]-margin-[pageControl(==height)]-margin-|", options:.alignAllCenterX, metrics: metrics, views:views))
        //横向
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[pageControl(==width)]", options:.alignAllLastBaseline, metrics: metrics, views:views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[startButton(==btnWidth)]", options:.alignAllLastBaseline, metrics: metrics, views:views))
        //中心位置
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute:.centerX, relatedBy:.equal, toItem: self.pageControl,attribute:.centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute:.centerX, relatedBy:.equal, toItem: self.startButton,attribute:.centerX, multiplier: 1, constant: 0))
    }
    
    //displayStartButton:显示进入按钮
    fileprivate func displayStartButton(_ show:Bool)
    {
        if(show)
        {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.startButton.layer.opacity=1
                }, completion: { (finished) -> Void in
                    
            }) 
        }
        else
        {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.startButton.layer.opacity=0
                }, completion: { (finished) -> Void in
                    
            }) 
        }
    }
    
    //scrollViewDidScroll:滚动时执行粘土动画
    override open func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        //Indicator动画
        self.pageControl.indicator.animateIndicator(scrollView, pageControl: self.pageControl)
        
        if (scrollView.isDragging || scrollView.isDecelerating || scrollView.isTracking)
        {
            //背景线条动画
            self.pageControl.pageControlLine().animateSelectedLineWithScrollView(scrollView)
        }
    }
    
    //scrollViewWillBeginDecelerating:将要开始滚动，重置指示器位置
    override open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        if(self.startButton.layer.opacity==1)
        {
            self.displayStartButton(false)
        }
        self.pageControl.indicator.restoreAnimation(1.0/Float(self.pageControl.pageCount))
    }
    
    //scrollViewDidEndDecelerating:停止滚动，记录最后滚动的位置
    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.pageControl.indicator.lastContentOffset=scrollView.contentOffset.x
        self.pageControl.selectedPage=Int(Double(scrollView.contentOffset.x)/Double((self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width))
        if(self.pageControl.selectedPage == self.collectionData!.count-1)
        {
            self.displayStartButton(true)
        }
    }
}
