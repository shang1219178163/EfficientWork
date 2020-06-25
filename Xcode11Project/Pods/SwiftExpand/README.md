# SwiftExpand
Swift SDK功能拓展 , Objective-C && Swift

## Usage：

**NNClassFromString**

    //get class by name
    public func NNClassFromString(_ name: String) -> AnyClass? {
        if let cls = NSClassFromString(name) {
    //        print("✅_Objc类存在: \(name)")
            return cls;
         }
         
         let swiftClassName = "\(UIApplication.appBundleName).\(name)";
         if let cls = NSClassFromString(swiftClassName) {
    //         print("✅_Swift类存在: \(swiftClassName)")
             return cls;
         }
         print("❌_类不存在: \(name)")
        return nil;
    }
    
**UICtrFromString**
    
    /// get UIViewController by name
    public func UICtrFromString(_ vcName: String) -> UIViewController {
        let cls: AnyClass = NNClassFromString(vcName)!;
        // 通过类创建对象， 不能用cls.init(),有的类可能没有init方法
        // 需将cls转换为制定类型
        let vcCls = cls as! UIViewController.Type;
        // 创建对象
        let controller: UIViewController = vcCls.init();
        return controller;
    }

**UITableViewCell**

    /// custom - UITableViewCell
    class UITableViewCellOne: UITableViewCell {}
    
    /// Reusable
    let cell = UITableViewCellOne.dequeueReusableCell(tableView)

    /// custom - UITableViewHeaderFooterView
    class UITableHeaderFooterViewZero: UITableViewHeaderFooterView {}

    /// Reusable
    let view = UITableHeaderFooterViewZero.dequeueReusableHeaderFooterView(tableView)

**UICollectionViewCell**

    ctView.dictClass = [UICollectionView.elementKindSectionHeader: ["UICTReusableViewOne",],
                        UICollectionView.elementKindSectionFooter: ["UICTReusableViewZero",],
                        UICollectionView.elementKindSectionItem: ["UICTViewCellZero","UICTViewCellOne"],]
                        
    /// custom - UICollectionViewCell
    class UICTViewCellOne: UICollectionViewCell { )   
    /// Reusable
    let cell = collectionView.dequeueReusableCell(for: UICTViewCellZero.self, indexPath: indexPath)
    
    /// custom - UICollectionReusableView
    class UICTViewCellOne: UICollectionReusableView { )  
    /// Reusable
    let view = collectionView.dequeueReusableSupplementaryView(for: UICTReusableViewOne.self, kind: kind, indexPath: indexPath)

**DateFormatter**

    @objc public extension DateFormatter{
    /// 获取DateFormatter(默认格式)
    static func format(_ formatStr: String = kDateFormat) -> DateFormatter {
        let dic = Thread.current.threadDictionary;
        if dic.object(forKey: formatStr) != nil {
            return dic.object(forKey: formatStr) as! DateFormatter;
        }
        
        let fmt = DateFormatter();
        fmt.dateFormat = formatStr;
        fmt.locale = .current;
        fmt.locale = Locale(identifier: "zh_CN");
        fmt.timeZone = formatStr.contains("GMT") ? TimeZone(identifier: "GMT") : TimeZone.current;
        
        dic.setObject(fmt, forKey: formatStr as NSCopying)
        return fmt;
    }
    
    /// Date -> String
    static func stringFromDate(_ date: Date, fmt: String = kDateFormat) -> String {
        let formatter = DateFormatter.format(fmt);
        return formatter.string(from: date);
    }
    
    /// String -> Date
    static func dateFromString(_ dateStr: String, fmt: String = kDateFormat) -> Date {
        let formatter = DateFormatter.format(fmt);
        return formatter.date(from: dateStr)!;
    }
    
    /// 时间戳字符串 -> 日期字符串
    static func stringFromInterval(_ interval: String, fmt: String = kDateFormat) -> String {
        let date = Date(timeIntervalSince1970: interval.doubleValue)
        return DateFormatter.stringFromDate(date, fmt: fmt);
    }

    /// 日期字符串 -> 时间戳字符串
    static func intervalFromDateStr(_ dateStr: String, fmt: String = kDateFormat) -> String {
        let date = DateFormatter.dateFromString(dateStr, fmt: fmt)
        return "\(date.timeIntervalSince1970)";
    }
    
**UIBarButtonItem**

    @objc extension UIBarButtonItem{
        /// UIBarButtonItem 回调
        public func addAction(_ closure: @escaping (UIBarButtonItem) -> Void) {
            objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC);
            target = self;
            action = #selector(p_invoke);
        }
        
        private func p_invoke() {
            let closure = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!) as! ((UIBarButtonItem) -> Void)
            closure(self);
        }
    }
    
**UIGestureRecognizer**

    @objc extension UIGestureRecognizer{
    
        /// 闭包回调
        public func addAction(_ closure: @escaping (UIGestureRecognizer) -> Void) {
            objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC);
            addTarget(self, action: #selector(p_invoke))
        }
        
        private func p_invoke() {
            let closure = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!) as! ((UIGestureRecognizer) -> Void)
            closure(self);
        }
    }

**Get any pod bundle image**

    /// 获取 pod bundle 图片资源
    static func image(named name: String, podClassName: String, bundleName: String? = nil) -> UIImage?{
        let bundleNameNew = bundleName ?? podClassName
        if let image = UIImage(named: "\(bundleNameNew).bundle/\(name)") {
            return image;
        }

        let framework = Bundle.main
        let filePath = framework.resourcePath! + "/Frameworks/\(podClassName).framework/\(bundleNameNew).bundle"
        
        guard let bundle = Bundle(path: filePath) else { return nil}
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
        return image;
    }
    
**UIStackView**
    
    @objc public extension UIStackView {
        /// 设置子视图显示比例(此方法前请设置 .axis/.orientation)
        func setSubViewMultiplier(_ multiplier: CGFloat, at index: Int) {
            if index < subviews.count {
                let element = subviews[index];
                if self.axis == .horizontal {
                    element.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier).isActive = true
    
                } else {
                    element.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: multiplier).isActive = true
                }
            }
        }
    }
    
##  Requirements
    s.ios.deployment_target = '8.0'
    s.swift_version = "5.0"
    
##  Author

shang1219178163, shang1219178163@gmail.com

## License

CocoaExpand is available under the MIT license. See the LICENSE file for more info.