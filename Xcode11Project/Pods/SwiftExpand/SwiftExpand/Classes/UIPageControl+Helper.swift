//
//  UIPageControl+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/11/9.
//

import UIKit

@objc public extension UIPageControl{

    /// [源]UIPageControl创建
    static func create(_ rect: CGRect = .zero, numberOfPages: Int, currentPage: Int = 0) -> Self {
        let view = self.init(frame: rect);
        view.currentPageIndicatorTintColor = UIColor.theme;
        view.pageIndicatorTintColor = UIColor.lightGray;
        view.isUserInteractionEnabled = true;
        view.hidesForSinglePage = true;
        view.currentPage = 0;
        view.numberOfPages = numberOfPages;
        
        return view;
    }
}
