//
//  BGSelectImageLayout.swift
//  BGSimpleImageSelectCollectionView
//
//  Created by user on 15/10/27.
//  Copyright © 2015年 BG. All rights reserved.
//

import UIKit

protocol BGSelectImageLayoutDelegate: NSObjectProtocol {
    /**
     选择了某个索引
     
     - parameter layout:          layout
     - parameter selectIndexPath: 选择的索引
     */
    func selectImageLayout(layout: BGSelectImageLayout, selectIndexPath: NSIndexPath)
}

/// 此布局，只有一组，没有多组
class BGSelectImageLayout: UICollectionViewLayout {
    // MARK: - properties
    /// 内容区域
    var contentInset: UIEdgeInsets = UIEdgeInsetsZero
    /// 每个cell的间距
    var interitemSpacing: CGFloat = 10
    /// 每个cell大小
    var itemSize: CGSize = CGSizeMake(45, 45)
    /// 代理
    weak var delegate: BGSelectImageLayoutDelegate? = nil
    
    /// cell布局信息
    private var layoutInfoDic = [NSIndexPath:UICollectionViewLayoutAttributes]()
    
    /// 需要刷新的时候indexPath
    private var reloadIndexPathArr = [NSIndexPath]()
    /// 删除的indexPath集合
    private var deleteIndexPathArr = [NSIndexPath]()
    /// 插入的indexPath集合
    private var insertIndexPathArr = [NSIndexPath]()
    /// 移动前的indexPath
    private var beforeMoveIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    /// 移动后的indexPath
    private var afterMoveIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    /// 更新动画类型
    private var animationType:UICollectionUpdateAction = .None
    
    /// 上一次选中的indexPath
    private var lastSelectIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    /// 当前选中的indexPath
    private var currentSelectIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    /// 选中的indexPath
    var selectIndexPath: NSIndexPath {
        get {
            return self.currentSelectIndexPath
        }
        set (indexPath) {
            if indexPath != self.currentSelectIndexPath {
                self.lastSelectIndexPath = self.currentSelectIndexPath
                self.currentSelectIndexPath = indexPath
                self.collectionView?.reloadSections(NSIndexSet(index: 0))
                //调用代理方法
                self.delegate?.selectImageLayout(self, selectIndexPath: indexPath)
            }
            else{
                self.collectionView?.scrollToItemAtIndexPath(self.currentSelectIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            }
        }
    }
    
    // MARK: - must override methods
    override func prepareLayout() {
        super.prepareLayout()
        
        //重置数组
        self.layoutInfoDic = [NSIndexPath:UICollectionViewLayoutAttributes]()
        
        //布局只取第0组的信息
        if let numOfItems = self.collectionView?.numberOfItemsInSection(0) {
            for i in 0 ..< numOfItems {
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                if let attributes = self.layoutAttributesForItemAtIndexPath(indexPath) {
                    self.layoutInfoDic[indexPath] = attributes
                }
            }
        }
        
    }
    
    override func collectionViewContentSize() -> CGSize {
        if let numOfItems = self.collectionView?.numberOfItemsInSection(0) {
            return CGSizeMake((self.itemSize.width+self.interitemSpacing)*CGFloat(numOfItems+1)+self.interitemSpacing+self.contentInset.left+self.contentInset.right, self.itemSize.height+self.contentInset.top+self.contentInset.bottom)
        }
        else {
            return self.collectionView!.frame.size
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArr = [UICollectionViewLayoutAttributes]()
        //遍历布局信息
        for arttibutes in self.layoutInfoDic.values {
            //判断arttibutes当中的区域与rect是否存在交集
            if CGRectIntersectsRect(arttibutes.frame, rect) {
                attributesArr.append(arttibutes)
            }
        }
        return attributesArr
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = self.currentFrameWithIndexPath(indexPath)
        return attributes
    }
    
    // MARK: - option override method
//    //此方法刷新动画的时候会调用
//    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
//        let frame = self.currentFrameWithIndexPath(self.currentSelectIndexPath)
//        return CGPointMake(frame.centerX-self.collectionView!.width/2.0, 0)
//    }
    
    // MARK: animation method
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        //数组重置
        self.reloadIndexPathArr = [NSIndexPath]()
        self.deleteIndexPathArr = [NSIndexPath]()
        self.insertIndexPathArr = [NSIndexPath]()
        
        //保存更新的indexPath
        for item in updateItems {
            switch item.updateAction {
                case .Insert:
                    let indexPath = item.indexPathAfterUpdate
                    self.insertIndexPathArr.append(indexPath)
                    self.animationType = .Insert
                case .Delete:
                    let indexPath = item.indexPathBeforeUpdate
                    self.deleteIndexPathArr.append(indexPath)
                    self.animationType = .Delete
                case .Reload:
                    let indexPath = item.indexPathBeforeUpdate
                    self.reloadIndexPathArr.append(indexPath)
                    self.animationType = .Reload
                case .Move:
                    self.beforeMoveIndexPath = item.indexPathBeforeUpdate
                    self.afterMoveIndexPath = item.indexPathAfterUpdate
                    self.animationType = .Move
                case .None:
                    self.animationType = .None
                    break
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        
    }
    
  
    
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        //此处需要用到copy，否则属性变量一次变化之后，会被保存，然后会出现移动那个动画
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes
        switch self.animationType {
        case .Insert:
            if self.insertIndexPathArr.contains(itemIndexPath) {
                attributes?.transform = CGAffineTransformMakeScale(0.0, 0.0)
                attributes?.alpha = 0
            }
            else {
                //设置为前一个item的frame
                attributes?.frame = self.currentFrameWithIndexPath(NSIndexPath(forRow: itemIndexPath.row-1, inSection: itemIndexPath.section))
            }
        case .Delete:
            attributes?.frame = self.currentFrameWithIndexPath(NSIndexPath(forRow: itemIndexPath.row+1, inSection: itemIndexPath.section))
        case .Move:
            if itemIndexPath == self.afterMoveIndexPath {
                //afterMoveIndexPath的消失动画和beforeMoveIndexPath的出现动画重合
                //init是设置起点，而final设置终点，理论是不重合的
                attributes?.transform3D = CATransform3DMakeRotation(-1*CGFloat(M_PI), 0, 0, -1)
            }
        case .Reload:
            attributes?.frame = self.lastFrameWithIndexPath(itemIndexPath)
            
        default:
            break
        }
        print("init:")
        print(attributes)
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes
        switch self.animationType {
        case .Insert:
            attributes?.frame = self.currentFrameWithIndexPath(NSIndexPath(forRow: itemIndexPath.row+1, inSection: itemIndexPath.section))
        case .Delete:
            if self.deleteIndexPathArr.contains(itemIndexPath) {
                //这里写成缩放成(0，0)直接就不见了
                attributes?.transform = CGAffineTransformMakeScale(0.1, 0.1)
                attributes?.alpha = 0.0
            }
            else {
                attributes?.frame = self.currentFrameWithIndexPath(NSIndexPath(forRow: itemIndexPath.row-1, inSection: itemIndexPath.section))
            }
        case .Move:
            if self.beforeMoveIndexPath == itemIndexPath {
                //afterMoveIndexPath的消失动画和beforeMoveIndexPath的出现动画重合，设置他们旋转的角度一样，方向相反
                attributes?.transform3D = CATransform3DMakeRotation(-1*CGFloat(M_PI), 0, 0, -1)
            }
        case .Reload:
            attributes?.alpha = 1.0
            attributes?.frame = self.currentFrameWithIndexPath(itemIndexPath)
        default:
            break
        }
        print("fina:")
        print(attributes)
        return attributes
    }
    
    // MARK: - private method
    func currentFrameWithIndexPath(indexPath: NSIndexPath) -> CGRect {
        return self.frameWithIndexPath(indexPath, selectIndexPath: self.currentSelectIndexPath)
    }
    func lastFrameWithIndexPath(indexPath: NSIndexPath) -> CGRect {
        return self.frameWithIndexPath(indexPath, selectIndexPath: self.lastSelectIndexPath)
    }
    func frameWithIndexPath(indexPath: NSIndexPath, selectIndexPath: NSIndexPath) -> CGRect {
        var left: CGFloat
        var width: CGFloat
        if indexPath.row < selectIndexPath.row {
            left = CGFloat(indexPath.row)*(self.itemSize.width+self.interitemSpacing)
            width = self.itemSize.width
        }
        else if indexPath.row == selectIndexPath.row {
            left = CGFloat(indexPath.row)*(self.itemSize.width+self.interitemSpacing)+self.interitemSpacing
            width = self.itemSize.width*2
        }
        else {
            left = CGFloat(indexPath.row+1)*(self.itemSize.width+self.interitemSpacing)+self.interitemSpacing
            width = self.itemSize.width
        }
        let frame = CGRectMake(left+self.contentInset.left, CGFloat(indexPath.section)*self.itemSize.height+self.contentInset.top, width, self.itemSize.height)
        return frame
    }
    
    func printAttributes(attributes: UICollectionViewLayoutAttributes) {
        print("attributes:")
        print("frame:\(attributes.frame)")
        print("indexPath:\(attributes.indexPath)")
        print("transform:\(attributes.transform)")
        print("alpha:\(attributes.alpha)")
    }
}
