//
//  UISearchBar+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/10/9.
//

import UIKit

@objc public extension UISearchBar{

    /// [源]UISearchBar创建
    static func create(_ rect: CGRect) -> UISearchBar {
        let searchBar = UISearchBar(frame: rect)
        
        //设置背景色
//        searchBar.backgroundColor = UIColor.black.withAlphaComponent(0.1);
//        searchBar.layer.cornerRadius = rect.height*0.5;
//        searchBar.layer.masksToBounds = true;
        //设置背景图是为了去掉上下黑线
        searchBar.backgroundImage = UIImage();
        //searchBar.backgroundImage = [UIImage imageNamed:@"sexBankgroundImage"];
        // 设置SearchBar的主题颜色
        //searchBar.barTintColor = [UIColor colorWithRed:111 green:212 blue:163 alpha:1];

        
        searchBar.barStyle = .default;
        searchBar.keyboardType = .namePhonePad;
        //searchBar.searchBarStyle = UISearchBarStyleMinimal;
        //没有背影，透明样式
        // 修改cancel
//        searchBar.setValue("取消", forKey: "cancelButtonText")
//        searchBar.showsCancelButton = true;
        //    searchBar.showsSearchResultsButton = true;
        //5. 设置搜索Icon
        //    [searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        searchBar.setPositionAdjustment(UIOffset(horizontal: -8, vertical: 1), for: .search)
        // 删除按钮往右移一点
        searchBar.setPositionAdjustment(UIOffset(horizontal: 8, vertical: 0), for: .clear)
        
//        guard let textField: UITextField = (searchBar.findSubview(type: UITextField.self, resursion: true) as? UITextField) else { return searchBar; }
//        textField.backgroundColor = UIColor.clear
//        textField.tintColor = UIColor.gray;
//        textField.textColor = UIColor.white;
//        textField.font = UIFont.systemFont(ofSize: 13)
        searchBar.textField?.tintColor = UIColor.gray;
        searchBar.textField?.font = UIFont.systemFont(ofSize: 13)
        searchBar.textField?.borderStyle = .none;

        return searchBar;
    }
    
    var textField: UITextField? {
        get {
            var obj = objc_getAssociatedObject(self, RuntimeKeyFromSelector(#function)) as? UITextField;
            if obj == nil {
                obj = self.findSubview(type: UITextField.self, resursion: true) as? UITextField
                objc_setAssociatedObject(self, RuntimeKeyFromSelector(#function), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            return obj;
        }
    }
    
    var cancellBtn: UIButton? {
        if let btn = self.findSubview(type: (NSClassFromString("UINavigationButton") as! UIResponder.Type).self, resursion: true) as? UIButton {
            return btn;
        }
        return nil;
    }
    
}
