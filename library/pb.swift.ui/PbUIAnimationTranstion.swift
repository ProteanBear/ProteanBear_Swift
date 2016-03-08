//
//  PbUIAnimationTranstion.swift
//  Pods
//
//  Created by Maqiang on 16/3/7.
//
//

import Foundation
import UIKit

//动画协议
public protocol PbUIAnimationTranstionProtocol
{
    func pbUIAnimationFromView(viewController:UIViewController) -> UIView
    func pbUIAnimationToView(viewController:UIViewController) -> UIView
    func pbUIAnimationToViewHandle(viewController:UIViewController)
}

//缩放动画:进入
class PbUIAnimationTranstionScalePresent:NSObject,UIViewControllerAnimatedTransitioning
{
    //记录动画实现协议
    var delegate:PbUIAnimationTranstionProtocol?
    
    //初始化
    init(delegate:PbUIAnimationTranstionProtocol)
    {
        super.init()
        
        self.delegate=delegate
    }
    
    //指定转场动画持续的时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    //转场动画的具体内容
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        //1.获取动画的源控制器和目标控制器 
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let container = transitionContext.containerView()
        
        //2.创建一个Cell中imageView的截图，并把imageView隐藏，造成使用户以为移动的就是 imageView的假象
        let view=self.delegate!.pbUIAnimationFromView(fromVC!)
        let snapshotView = view.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = container!.convertRect(view.frame, fromView: view)
        view.hidden = true
        
        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1 
        toVC!.view.frame = transitionContext.finalFrameForViewController(toVC!)
        toVC!.view.alpha = 0
        
        //4.都添加到 container 中。注意顺序不能错了 
        container!.addSubview(toVC!.view)
        container!.addSubview(snapshotView)
        
        //5.执行动画 
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options:.CurveEaseInOut, animations: { () -> Void in
            
            snapshotView.frame = self.delegate!.pbUIAnimationToView(toVC!).frame
            toVC!.view.alpha = 1
            
            }) { (finished) -> Void in
                if(finished)
                {
                    self.delegate!.pbUIAnimationFromView(fromVC!).hidden = false
                    self.delegate!.pbUIAnimationToViewHandle(toVC!)
                    snapshotView.removeFromSuperview()
                    
                    //一定要记得动画完成后执行此方法，让系统管理 navigation 
                    transitionContext.completeTransition(true)
                }
        }
    }
}

//缩放动画：回退
class PbUIAnimationTranstionScaleDismiss:NSObject,UIViewControllerAnimatedTransitioning
{
    //记录动画实现协议
    var delegate:PbUIAnimationTranstionProtocol?
    
    //初始化
    init(delegate:PbUIAnimationTranstionProtocol)
    {
        super.init()
        
        self.delegate=delegate
    }
    
    //指定转场动画持续的时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.5
    }
    
    //转场动画的具体内容
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        //1.获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let container = transitionContext.containerView()
    }
}