//
//  UIButton+BGExtension.swift
//  BGPhotoPickerControllerDemo
//
//  Created by user on 15/10/15.
//  Copyright © 2015年 BG. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title:String, titleColor:UIColor, font: UIFont, textAlignment: NSTextAlignment = NSTextAlignment.Center) {
        self.init(frame:CGRectZero)
        self.setupButton(title, titleColor: titleColor, font: font, textAlignment: textAlignment)
    }
    
    convenience init(title:String, titleColor:UIColor, font: UIFont, backgroundColor: UIColor = UIColor.clearColor()) {
        self.init(frame:CGRectZero)
        self.setupButton(title, titleColor: titleColor, font: font, backgroundColor: backgroundColor, frame: CGRectZero, buttonType: UIButtonType.Custom)
    }
    
    convenience init(title:String, titleColor:UIColor, font: UIFont, frame: CGRect = CGRectZero) {
        self.init(frame: frame)
        self.setupButton(title, titleColor: titleColor, font: font, backgroundColor: UIColor.clearColor(), frame: frame, buttonType: UIButtonType.Custom)
    }
    
    convenience init(title:String, titleColor:UIColor, font: UIFont, backgroundColor: UIColor = UIColor.clearColor(), frame: CGRect = CGRectZero, buttonType: UIButtonType) {
        self.init(frame:frame)
        self.setupButton(title, titleColor: titleColor, font: font, backgroundColor: backgroundColor, frame: frame, buttonType: buttonType)
    }
    
    private func setupButton(title:String, titleColor:UIColor, font: UIFont, textAlignment: NSTextAlignment = NSTextAlignment.Center, backgroundColor: UIColor = UIColor.clearColor(), frame: CGRect = CGRectZero, buttonType: UIButtonType = UIButtonType.Custom){
        
    }
}