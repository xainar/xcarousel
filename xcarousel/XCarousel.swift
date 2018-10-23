//
//  XCarousel.swift
//  xcarousel
//
//  Created by osx on 10/22/18.
//  Copyright © 2018 osx. All rights reserved.
//

import UIKit

public struct Banner {
    let name: String
    let link: String
    let image: String
}

class XCarousel: UIView {
    private var pageControl:UIPageControl!
    private var collectionView:UICollectionView!
    private var layout:UICollectionViewFlowLayout!
    private var currentIndex: Int = 0
    public enum direction: Int { case left = -1, none, right }
    open var data: [Banner] = [Banner]()  {
        didSet {
            reloadData()
        }
    }
    
    open var timeInterVal: TimeInterval = 0  {
        didSet {
            if timeInterVal > 0 {
                startAutoScroll()
            } else {
                stopAutoScroll()
            }
        }
    }
    var timer:Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.green
        layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right:0.0)
        //layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = frame.size
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 0.0
        //layout.estimatedItemSize = frame.size
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: layout)
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CustomCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        initialization()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        stopAutoScroll()
    }
    //MARK:- initialize method
    func initialization() {
        initWithPageControl()
        setNeedsDisplay()
    }
    fileprivate func initWithPageControl() {
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.center = CGPoint.init(x: frame.size.width / 2, y: frame.size.height - 10)
        addSubview(pageControl)
    }
    
    func reloadData() {
        pageControl.numberOfPages = data.count
        pageControl.currentPage = 0
        collectionView.reloadData()
    }
    
    @objc fileprivate func autoScrollToNextView() {
        if data.count > 0 {
            let contentOffset = collectionView.contentOffset;
            if currentIndex < data.count - 1 {
                collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + layout.itemSize.width, y: contentOffset.y, width: layout.itemSize.width, height: layout.itemSize.height), animated: true)
            } else {
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            }
        }
    }
    
    //MARK:- UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = currentIndex
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        pageControl.currentPage = currentIndex
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if data.count == 0  { return }
    }
    
    
    func startAutoScroll() {
        if timeInterVal > 0 {
            timer = Timer()
            timer = Timer.scheduledTimer(timeInterval: timeInterVal, target: self, selector: #selector(autoScrollToNextView), userInfo: nil, repeats: true)
        }
    }
    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
}
extension XCarousel: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCell {
            let banner = data[indexPath.row]
            cell.cover.image = UIImage(named: banner.image)
            cell.name.text = banner.name
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = data[indexPath.row]
        let url = NSURL(string: banner.link)
        if (UIApplication.shared.canOpenURL(url! as URL)) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: { (opened) in
            })
        }
    }
}
