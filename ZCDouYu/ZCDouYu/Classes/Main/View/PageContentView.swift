//
//  PageContentView.swift
//  ZCDouYu
//
//  Created by 赵隆杰 on 16/9/18.
//  Copyright © 2016年 赵隆杰. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    //定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    //懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        //1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()
    
    init(frame: CGRect, childcs : [UIViewController], parentViewController : UIViewController?) {
        self.childVcs = childcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//设置UI界面
extension PageContentView {
    private func setupUI() {
        //1.将我们的所有子控制器添加到父控制器中
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        
        //2.添加UIControllerView,用于Cell中存放控制器的View
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//遵守UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.创建Cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ContentCellID, forIndexPath: indexPath)
        
        //2.给Cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        //1. 定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        //3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex : Int) {
        
        //1.记录需要禁止执行代理方法
        isForbidScrollDelegate = true
        
        //2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}


