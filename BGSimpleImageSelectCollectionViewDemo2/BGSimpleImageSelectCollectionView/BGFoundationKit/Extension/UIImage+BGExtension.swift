//
//  UIImage+BGExtension.swift
//  BGFoundationKitDemo
//
//  Created by user on 15/10/15.
//  Copyright © 2015年 BG. All rights reserved.
//

import UIKit

extension UIImage {
    static func image(color: UIColor, size: CGSize) -> UIImage{
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}