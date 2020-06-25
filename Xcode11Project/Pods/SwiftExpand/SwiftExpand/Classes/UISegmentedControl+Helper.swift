//
//  UISegmentedControl+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/1/9.
//

import UIKit

@objc public extension UISegmentedControl{

    /// [源]UISegmentControl创建
    static func create(_ rect: CGRect = .zero, items: [Any]?, selectedIdx: Int = 0, type: Int = 0, tintColor: UIColor = .theme, fontSize: CGFloat = 13) -> Self {
        let view = self.init(items: items)
        view.frame = rect
        view.autoresizingMask = .flexibleWidth
        view.selectedSegmentIndex = selectedIdx
        
        if #available(iOS 13, *) {
            view.ensureiOS12Style(tintColor: tintColor, fontSize: fontSize)
            return view;
        }
        
        switch type {
        case 1:
            view.tintColor = UIColor.theme
            view.backgroundColor = UIColor.white
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.white.cgColor
            let dicN = [NSAttributedString.Key.foregroundColor: UIColor.black,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                         
                         ]
            view.setTitleTextAttributes(dicN, for: .normal)
            view.setDividerImage(UIImage(color: UIColor.white), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default);
            
        case 2:
            view.tintColor = UIColor.white
            view.backgroundColor = UIColor.white
            
            let dicN = [NSAttributedString.Key.foregroundColor: UIColor.black,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                         ]
            
            let dicH = [NSAttributedString.Key.foregroundColor: UIColor.theme,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                         ]
            view.setTitleTextAttributes(dicN, for: .normal)
            view.setTitleTextAttributes(dicH, for: .selected)
            
        case 3:
            view.tintColor = UIColor.clear
            view.backgroundColor = UIColor.line
            
            let dicN = [NSAttributedString.Key.foregroundColor: UIColor.black,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                         ]
            
            let dicH = [NSAttributedString.Key.foregroundColor: UIColor.theme,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                         ]
            view.setTitleTextAttributes(dicN, for: .normal)
            view.setTitleTextAttributes(dicH, for: .selected)
            
        default:
            view.tintColor = UIColor.theme
            view.backgroundColor = UIColor.white
            
            let dicN = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                        ]
            let dicH = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
                        ]
            view.setTitleTextAttributes(dicN, for: .normal)
            view.setTitleTextAttributes(dicH, for: .selected)
        }
        return view;
    }
    
    /// Tint color doesn't have any effect on iOS 13.
    func ensureiOS12Style(tintColor: UIColor = .theme, fontSize: CGFloat = 13) {
        if #available(iOS 13, *) {
            let tintColorImage = UIImage(color: tintColor)
            // Must set the background image for normal to something (even clear) else the rest won't work
            setBackgroundImage(UIImage(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            setBackgroundImage(UIImage(color: tintColor), for: .highlighted, barMetrics: .default)
            setBackgroundImage(UIImage(color: .white), for: [.highlighted, .selected], barMetrics: .default)
            
            setTitleTextAttributes([.foregroundColor: tintColor as Any,
                                    .font: UIFont.systemFont(ofSize: fontSize)], for: .normal)
            setTitleTextAttributes([.foregroundColor: UIColor.white,
                                    .font: UIFont.systemFont(ofSize: fontSize)], for: .highlighted)
            setTitleTextAttributes([.foregroundColor: UIColor.white,
                                    .font: UIFont.systemFont(ofSize: fontSize)], for: .selected)
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            setDividerImage(UIImage(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            setDividerImage(UIImage(color: UIColor.clear), forLeftSegmentState: .highlighted, rightSegmentState: .normal, barMetrics: .default)
            
            layer.borderWidth = 1.0;
            layer.borderColor = tintColor.cgColor;
            layer.masksToBounds = true;
            layer.cornerRadius = 1.0;

        }
    }
    
    /// 控件items
    var itemList: [String] {
        get {
            return objc_getAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function)) as! [String]
        }
        set {
            objc_setAssociatedObject(self, RuntimeKeyFromSelector(self, aSelector: #function), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            updateItems(newValue)
        }
    }
        
    /// 配置新item数组
    private func updateItems(_ items: [String]) {
        if items.count == 0 {
            return
        }
        
        removeAllSegments()
        for e in items.enumerated() {
            insertSegment(withTitle: e.element, at: e.offset, animated: false)
        }
        selectedSegmentIndex = 0
    }
    
}
