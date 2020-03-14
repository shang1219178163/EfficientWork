
//
//  NSArray+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/6.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

public extension Array{
    
    func subarray(_ range: NSRange) -> Array {
        return self.subarray(range.location, range.length)
    }
    
    func subarray(_ loc: Int, _ len: Int) -> Array {
        assert(loc < self.count);
        return Array(self[loc...len]);
    }

    static func itemPrefix(prefix: String, count: Int, type: Int) -> Array! {
        var marr:[Any] = [];
        for i in 0...count {
            let item = String(format: "%@%d", prefix,i);
            
            switch type {
            case 1:
                let image = UIImage(named: item)!;
                marr.append(image);
            default:
                marr.append(item);
            }
        }
        return (marr as! Array<Element>);
    }
    
    ///添加多个相同元素到数组
    mutating func appendSame(_ item: Element, count: Int) {
        for _ in self.enumerated() {
            append(item)
        }
    }
    
    ///添加多个相同元素到数组
    static func appendSame(_ item: AnyObject, count: Int) -> [AnyObject] {
        var list: [AnyObject] = []
        for _ in 0..<count {
            list.append(item)
        }
        return list
    }
    
    ///模型(继承于NSObject)query对应属性为@objc声明的字符串
    func filterModelList(_ list: [AnyObject]!, querys: [String]) -> [[String]] {
        var listArr: [[String]]?
        for e in list.enumerated() {
            var itemList:[String]?
            querys.forEach({ (query) in
                let value = e.element.value(forKeyPath: query) ?? ""
                itemList?.append(value as! String)
            })
            listArr?.append(itemList!)
        }
        return listArr!
    }
    
    ///模型(继承于NSObject)query对应属性为@objc声明的字符串
    func filterModelList(_ list: [AnyObject], query: String) -> [String] {
        var itemList:[String] = []
        list.forEach { (obj:AnyObject) in
            
            let value = obj.value(forKeyPath: query) != nil ? obj.value(forKeyPath: query) : ""
            itemList.append(value as! String)
            
        }
        return itemList
    }
 
}

@objc public extension NSArray{

    /// 快速生成一个数组(step代表步长)
    static func range(_ start: Int = 0, _ end: Int, _ step: Int = 1) -> [Int] {
        assert(start < end);
        
        var list: [Int] = [];
        
        let count = end - start + 1;
        var k = 0;
        
        for i in 0..<count {
            k = start + step*i;
            if k < end {
                list.append(k)
            }
        }
        return list
    }
    
}
