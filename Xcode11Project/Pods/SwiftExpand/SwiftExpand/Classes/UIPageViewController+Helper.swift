//
//  UIPageViewController+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/6/16.
//  Copyright © 2020 BN. All rights reserved.
//

import UIKit

@objc public extension UIPageViewController {

    var pageControl: UIPageControl? {
        if let sender = self.view.subView(UIPageControl.self) as? UIPageControl{
            sender.pageIndicatorTintColor = UIColor.lightGray
            sender.currentPageIndicatorTintColor = UIColor.systemBlue
            return sender;
        }
        return nil;
    }
    var queuingScrollView: UIScrollView? {
        if let sender = self.view.subView(UIScrollView.self) as? UIScrollView{
            return sender;
        }
        return nil;
    }
    
    

}
