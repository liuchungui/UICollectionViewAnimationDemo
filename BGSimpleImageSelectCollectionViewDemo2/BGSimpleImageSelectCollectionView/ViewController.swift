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
    var imageNameArr = ["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg", "6.jpg", "7.jpg", "8.jpg", "9.jpg", "10.jpg", "11.jpg", "12.jpg", "13.jpg"]
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
        layout.itemSize = CGSizeMake(40, 100)
        layout.contentInset = UIEdgeInsetsMake(0, MainScreenWidth/2.0-layout.itemSize.width-layout.interitemSpacing, 0, MainScreenWidth/2.0-layout.itemSize.width-layout.interitemSpacing)
//        layout.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
        return self.imageNameArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: BGPhotoPreviewCell = collectionView.dequeueReusableCellWithReuseIdentifier(BGPhotoPreviewCell.reuseIdentify(), forIndexPath: indexPath) as! BGPhotoPreviewCell
        cell.imageView.contentMode = .ScaleToFill
        cell.imageView.clipsToBounds = true
        if let image = UIImage(named: self.imageNameArr[indexPath.row]) {
            cell.imageView.image = image
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate method
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectIndex = indexPath.row
        if let flowLayout = self.layout {
            flowLayout.selectIndexPath = indexPath
        }
    }

    // MARK: - button action
    @IBAction func insertAction(sender: AnyObject) {
        //插入
        if let inserIndexPath = self.layout?.selectIndexPath {
            self.imageNameArr.insert(self.getImageRandName(), atIndex: inserIndexPath.row)
            self.collectionView?.insertItemsAtIndexPaths([inserIndexPath])
        }
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        //删除
        if let deleteIndexPath = self.layout?.selectIndexPath {
            if self.imageNameArr.count > deleteIndexPath.row {
                self.imageNameArr.removeAtIndex(deleteIndexPath.row)
                self.collectionView?.deleteItemsAtIndexPaths([deleteIndexPath])
            }
        }
    }
    
    @IBAction func moveAction(sender: AnyObject) {
        //移动
        if let selectIndexPath = self.layout?.selectIndexPath {
            if self.imageNameArr.count - 2  > selectIndexPath.row {
                let targetIndexPath = NSIndexPath(forRow: selectIndexPath.row+2, inSection: selectIndexPath.section)
                self.collectionView?.moveItemAtIndexPath(selectIndexPath, toIndexPath: targetIndexPath)
                //改变数据源
                let lastName = self.imageNameArr[selectIndexPath.row]
                self.imageNameArr.removeAtIndex(selectIndexPath.row)
                self.imageNameArr.insert(lastName, atIndex: selectIndexPath.row+2)
                
            }
        }
    }
    
    //MARK: get image
    func getImageRandName() -> String {
        let randNum = random()
        return "\(randNum%13+1).jpg"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

