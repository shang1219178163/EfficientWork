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
        let control = self.init(frame: rect);
        control.currentPageIndicatorTintColor = UIColor.theme;
        control.pageIndicatorTintColor = UIColor.lightGray;
        control.isUserInteractionEnabled = true;
        control.hidesForSinglePage = true;
        control.currentPage = 0;
        control.numberOfPages = numberOfPages;
        
        return control;
    }
}
