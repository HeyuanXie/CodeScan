//
//  UIViewExtension.swift
//  QooccHealth
//
//  Created by LiuYu on 15/4/25.
//  Copyright (c) 2015年 Juxi. All rights reserved.
//

import UIKit 
private let kTagBadgeLabel = 20087


/**
*  @author LiuYu, 15-04-25 15:04:25
*
*  做一个有BadgeValue的扩展，默认的显示位置是在右上角
*/
extension UIView {
    /// 设置BadgeValue的值和位置,  nil: 隐藏，  "": 小红点， "str": 显示str
    var badgeValue: String? {
        get {
            return (self.viewWithTag(kTagBadgeLabel) as? UILabel)?.text
        }
        set {
            if newValue == nil { // 当设置nil的时候，删除所有相关的View
                self.viewWithTag(kTagBadgeLabel)?.removeFromSuperview()
            }
            else {
                let offsetTop: CGFloat = 10
                let offsetRight: CGFloat = 10
                let height: CGFloat = 18
                self.clipsToBounds = false
                var badgeLabel: UILabel! = self.viewWithTag(kTagBadgeLabel) as? UILabel
                if badgeLabel == nil {
                    badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: offsetTop*2, height: offsetRight*2))
                    badgeLabel.tag = kTagBadgeLabel
                    badgeLabel.autoresizingMask = .flexibleLeftMargin
                    badgeLabel.textColor = UIColor.white
                    badgeLabel.backgroundColor = UIColor(red: 234/255.0, green: 61/255.0, blue: 60/255.0, alpha: 1.0)
                    badgeLabel.textAlignment = .center
                    badgeLabel.layer.masksToBounds = true
                    badgeLabel.font = UIFont.systemFont(ofSize: 12)
                    self.addSubview(badgeLabel)
                }
                
                if newValue != "" { // 当设置str的时候，显示str
                    badgeLabel.text = newValue!
                    badgeLabel.sizeToFit()
                    badgeLabel.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: max(height, badgeLabel.bounds.width + 10/*增加一个偏移值*/), height: height))
                }
                else { // 当设置""的时候，显示小红点
                    badgeLabel.text = newValue!
                    badgeLabel.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 10))
                }
                badgeLabel.layer.cornerRadius = badgeLabel.bounds.height/2.0
                badgeLabel.frame = CGRect(origin: CGPoint(x: self.bounds.width - offsetRight - badgeLabel.bounds.height/2.0, y: offsetTop - badgeLabel.bounds.height/2.0), size: badgeLabel.bounds.size)
            }
        }
    }
    
    /**
    设置BadgeValue的值和位置
    
    :param: badgeValue 值
    :param: center     中心点位置
    */
    func setBadgeValue(badgeValue: String?, center: CGPoint) {
        self.badgeValue = badgeValue
        self.viewWithTag(kTagBadgeLabel)?.center = center
    }
}
//方便自定义窗口弹出
extension UIView {
    //点击阴影移除窗口
    public func showAsPopAndhideWhenClickGray() {
        let rect = UIScreen.main.bounds
        let frontToBackWindows = UIApplication.shared.windows.reversed()
        for window in frontToBackWindows {
            let windowOnMainScreen = window.screen == UIScreen.main
            let windowIsVisible = !window.isHidden && window.alpha > 0
            let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                window.addSubview(self)
                
                
                let btn = UIButton(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
                btn.backgroundColor = UIColor.clear
                btn.rac_signal(for: .touchUpInside).subscribeNext({ (sender) -> Void in
                    self.removePop()
                    (sender as! UIButton).removeFromSuperview()
                })
                window.addSubview(btn)
                break
            }
        }
        //动画
        self.layer.opacity = 0.5;
        self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) //半透明色值
            self.layer.opacity = 1.0
            self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }) { (finished) -> Void in
        }
    }
 
    public func showAsPop(setBgColor isSetBgColor : Bool  = true) {
        let frontToBackWindows = UIApplication.shared.windows.reversed()
        for window in frontToBackWindows {
            let windowOnMainScreen = window.screen == UIScreen.main
            let windowIsVisible = !window.isHidden && window.alpha > 0
            let windowLevelNormal = window.windowLevel == UIWindowLevelNormal
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                window.addSubview(self)
                break
            }
        }
        self.layer.opacity = 0.5;
        self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            if isSetBgColor {
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4) //半透明色值
            }
            self.layer.opacity = 1.0
            self.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }) { (finished) -> Void in
        }
    }
    public func removePop() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [UIViewAnimationOptions.curveEaseIn , UIViewAnimationOptions.allowUserInteraction], animations: { () -> Void in
            self.alpha = 0
            self.transform = self.transform.scaledBy(x: 0.8,y: 0.8);
            }) { (finished) -> Void in
                self.canPerformAction(#selector(UIView.removeFromSuperview), withSender: self)
        }
    }
}

extension UIView {
    /**通过UIView得到他的UIViewController*/
    public func getController()->UIViewController?{
        var next:UIView? = self
        repeat{
            if let nextResponder = next?.next, nextResponder.isKind(of:UIViewController.self){
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        }while next != nil
        return nil
    }
}




