//
//  UICollectionViewCell+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2018/12/22.
//

import UIKit

@objc public extension UICollectionViewCell{
    
    /// [源]自定义 UICollectionViewCell 获取方法(兼容OC)
    static func dequeueReusableCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell{
        let identifier = self.identifier;
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return view;
    }

 
}
