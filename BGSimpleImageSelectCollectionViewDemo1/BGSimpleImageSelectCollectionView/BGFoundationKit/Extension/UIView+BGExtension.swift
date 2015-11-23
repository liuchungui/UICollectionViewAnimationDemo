//
//  UIView+BGExtension.swift
//  BGFoundationKitDemo
//
//  Created by user on 15/10/15.
//  Copyright © 2015年 BG. All rights reserved.
//

import UIKit

extension UIView {
    /** 重用的标示，默认以类名为标示 */
    class func reuseIdentify() -> String {
        return String(self)
    }
    
    /** 加载xib文件 */
    static func loadFromXib() -> AnyObject {
        let array = NSBundle.mainBundle().loadNibNamed(String(self), owner: self, options: nil)
        return array.first!
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set (newValue){
            self.frame.origin.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set (newValue){
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set (newValue){
            self.frame.origin.y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set (newValue){
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set (newValue) {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set (newValue) {
            self.frame.size.height = newValue
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set (newValue) {
            self.center.x = newValue
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set (newValue) {
            self.center.y = newValue
        }
    }
    
}
