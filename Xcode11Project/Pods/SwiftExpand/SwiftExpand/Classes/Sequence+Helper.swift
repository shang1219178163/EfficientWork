
//
//  Sequence+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/17.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit
import Foundation

public extension Sequence{
    
    func all(matching predicate: (Element) -> Bool) -> Bool {
        // 对于一个条件，如果没有元素不满足它的话，那意味着所有元素都满足它：
        return !contains { !predicate($0) }
    }
    
    
//    public func last(where predicate:(Element) -> Bool) -> Element? {
//
//        for element in reversed() where predicate(Element) {
//            return element;
//        }
//        return nil;
//    }
//
    
}

public extension Sequence where Element: Hashable{
    
//    var frequencies: [Element: Int]{
//        let frequencyPairs = self.map{($0,1)}
//        return Dictionary(frequencyPairs,uniquingKeysWith:+);
//    }
    
}

