//
//  ViewController.swift
//  BGSimpleImageSelectCollectionView
//
//  Created by user on 15/10/17.
//  Copyright © 2015年 BG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var imageView: UIImageView!
    var colorArr = [UIColorFromHexColor(0xFF0000), UIColorFromHexColor(0xFF00), UIColorFromHexColor(0xFF), UIColorFromHexColor(0xFF0000), UIColorFromHexColor(0xFFFF00), UIColorFromHexColor(0xFF00FF), UIColorFromHexColor(0xFFFF), UIColorFromHexColor(0x111111), UIColorFromHexColor(0x731083), UIColorFromHexColor(0xFF10F0), UIColorFromHexColor(0x0FFF10), UIColorFromHexColor(0xFF100F), UIColorFromHexColor(0xE80F00), UIColorFromHexColor(0xFF0F0F)];
    var selectIndex = 0
    var layout: BGSelectImageLayout?
    var collectionView: UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCollectionView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createCollectionView() {
        let layout = BGSelectImageLayout()
        layout.itemSize = CGSizeMake(80, 200)
//        layout.contentInset = UIEdgeInsetsMake(0, MainScreenWidth/2.0-layout.itemSize.width-layout.interitemSpacing, 0, MainScreenWidth/2.0-layout.itemSize.width-layout.interitemSpacing)
        layout.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.layout = layout
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: MainScreenWidth, height: MainScreenHeight-250), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        
        collectionView.registerNib(UINib(nibName: BGPhotoPreviewCell.reuseIdentify(), bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: BGPhotoPreviewCell.reuseIdentify())
        collectionView.registerClass(UIView.self, forSupplementaryViewOfKind: UIView.reuseIdentify(), withReuseIdentifier: UIView.reuseIdentify())
    }
    
    // MARK: - UICollectionViewDataSource method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: BGPhotoPreviewCell = collectionView.dequeueReusableCellWithReuseIdentifier(BGPhotoPreviewCell.reuseIdentify(), forIndexPath: indexPath) as! BGPhotoPreviewCell
        cell.backgroundColor = self.colorArr[indexPath.row]
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate method
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectIndex = indexPath.row
        if let flowLayout = self.layout {
            flowLayout.selectIndexPath = indexPath
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == self.selectIndex {
            return CGSizeMake(120, 100)
        }
        else {
            return CGSizeMake(60, 100)
        }
    }

    // MARK: - button action
    @IBAction func insertAction(sender: AnyObject) {
        //插入
        if let inserIndexPath = self.layout?.selectIndexPath {
            self.colorArr.insert(self.getColorWithIndex(self.colorArr.count), atIndex: inserIndexPath.row)
            self.collectionView?.insertItemsAtIndexPaths([inserIndexPath])
        }
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        //删除
        if let deleteIndexPath = self.layout?.selectIndexPath {
            if self.colorArr.count > deleteIndexPath.row {
                self.colorArr.removeAtIndex(deleteIndexPath.row)
                self.collectionView?.deleteItemsAtIndexPaths([deleteIndexPath])
            }
        }
    }
    
    @IBAction func moveAction(sender: AnyObject) {
        //移动
        if let selectIndexPath = self.layout?.selectIndexPath {
            if self.colorArr.count - 2  > selectIndexPath.row {
                let targetIndexPath = NSIndexPath(forRow: selectIndexPath.row+2, inSection: selectIndexPath.section)
                self.collectionView?.moveItemAtIndexPath(selectIndexPath, toIndexPath: targetIndexPath)
                //改变数据源
                let lastColor = self.colorArr[selectIndexPath.row]
                self.colorArr.removeAtIndex(selectIndexPath.row)
                self.colorArr.insert(lastColor, atIndex: selectIndexPath.row+2)
                
            }
        }
    }
    
    //MARK: get color
    func getColorWithIndex(index: Int) -> UIColor {
        let colors = [UIColorFromHexColor(0xFF0000), UIColorFromHexColor(0xFF00), UIColorFromHexColor(0xFF), UIColorFromHexColor(0xFF0000), UIColorFromHexColor(0xFFFF00), UIColorFromHexColor(0xFF00FF), UIColorFromHexColor(0xFFFF), UIColorFromHexColor(0x111111), UIColorFromHexColor(0x731083), UIColorFromHexColor(0xFF10F0), UIColorFromHexColor(0x0FFF10), UIColorFromHexColor(0xFF100F), UIColorFromHexColor(0xE80F00), UIColorFromHexColor(0xFF0F0F)]
        let i = index % colors.count
        return colors[i];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

