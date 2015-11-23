//
//  BGPhotoPreviewCell.swift
//  BGPhotoPickerControllerDemo
//
//  Created by user on 15/10/14.
//  Copyright © 2015年 BG. All rights reserved.
//

import UIKit

class BGPhotoPreviewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    override func setNeedsUpdateConstraints() {
        super.setNeedsUpdateConstraints()
    }
//    override var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set(newValue) {
//            super.frame = newValue
//            self.layoutIfNeeded()
//        }
//    }
    
    override func updateConstraints() {
        self.layoutIfNeeded()
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
