//
//  UIView+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/14.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc extension UIView{
    
//    // 混编和masonry冲突
//    public var x: CGFloat {
//        get {
//            return frame.origin.x
//        }
//        set {
//            frame.origin = CGPoint(x:newValue, y:frame.origin.y)
//        }
//    }
//    // 混编和masonry冲突
//    public var y: CGFloat {
//        get {
//            return frame.origin.y
//        }
//        set {
//            frame.origin = CGPoint(x:frame.origin.x, y:newValue)
//        }
//    }
//    // 混编和masonry冲突
//    public var width: CGFloat {
//        get {
//            return frame.width
//        }
//        set {
//            frame.size.width = newValue
//        }
//    }
//    // 混编和masonry冲突
//    public var height: CGFloat {
//        get {
//            return frame.size.height
//        }
//        set {
//            frame.size.height = newValue
//        }
//    }
    
    public var sizeWidth: CGFloat {
        get {
            return frame.size.width
        }
        set {
//            frame.size.width = newValue
            var rectTmp = frame;
            rectTmp.size.width = newValue;
            frame = rectTmp;
        }
    }
    
    public var sizeHeight: CGFloat {
        get {
            return frame.size.height
        }
        set {
//            frame.size.height = newValue
            var rectTmp = frame;
            rectTmp.size.height = newValue;
            frame = rectTmp;
        }
    }
    
    public var size: CGSize  {
        get {
            return frame.size
        }
        set{
//            frame.size = newValue
            var rectTmp = frame;
            rectTmp.size = newValue;
            frame = rectTmp;
        }
    }
    
    public var originX: CGFloat {
        get {
            return frame.origin.x
        }
        set {
//            frame.origin.x = newValue
            var rectTmp = frame;
            rectTmp.origin.x = newValue;
            frame = rectTmp;
        }
    }
    
    public var originY: CGFloat {
        get {
            return frame.origin.y
        }
        set {
//            frame.origin.y = newValue
            var rectTmp = frame;
            rectTmp.origin.y = newValue;
            frame = rectTmp;
        }
    }
    
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
//            frame.origin = newValue
            var rectTmp = frame;
            rectTmp.origin = newValue;
            frame = rectTmp;
        }
    }
    
    public var minX: CGFloat {
        return frame.minX
    }
    
    public var minY: CGFloat {
        return frame.minY
    }
    
    public var midX: CGFloat {
        return frame.midX
    }
    
    public var midY: CGFloat {
        return frame.midY
    }
    
    public var maxX: CGFloat {
        return frame.maxX
    }
    
    public var maxY: CGFloat {
        return frame.maxY
    }
    
    //MARK: -funtions
    /// text是否有效
    public func validText() -> Bool {
        assert(isKind(of: UITextView.classForCoder())
            || isKind(of: UITextField.classForCoder())
            || isKind(of: UILabel.classForCoder()))
        
        var value = self.value(forKey: "text") as? String
        if value == nil {
            return false;
        }
        value = value!.replacingOccurrences(of: " ", with: "")
        
        let textNulls = ["", "nil", "null",  "NULL"];
        if textNulls.contains(value!) {
            return false
        }
        return true;
    }

    public func autoresizeMask() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    /// 图层调试
    public func getViewLayer(lineColor: UIColor = .blue) {
        let subviews = self.subviews;
        if subviews.count == 0 {
            return;
        }
        for subview in subviews {
            subview.layer.borderWidth = kW_LayerBorder;
            subview.layer.borderColor = lineColor.cgColor;
//            subview.layer.borderColor = UIColor.clear.cgColor;

            subview.getViewLayer();
        }
    }
    
    /// 寻找子视图
    public func findSubview(type: UIResponder.Type, resursion: Bool)-> UIView? {
        for e in self.subviews.enumerated() {
            if e.element.isKind(of: type) {
                return e.element;
            }
        }
        
        if resursion == true {
            for e in self.subviews.enumerated() {
                let tmpView = e.element.findSubview(type: type, resursion: resursion)
                if tmpView != nil {
                    return tmpView;
                }
            }
        }
        return nil;
    }
    
    /// 移除所有子视图
    public func removeAllSubViews(){
        subviews.forEach { (view: UIView) in
            view.removeFromSuperview()
        }
    }
    
    public func addCorners(_ corners: UIRectCorner = UIRectCorner.allCorners,
                          cornerRadii: CGSize = CGSize(width: 8.0, height: 8.0),
                          width: CGFloat = 1,
                          color: UIColor = UIColor.gray) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = path.cgPath
        maskLayer.borderWidth = width
        maskLayer.borderColor = color.cgColor
        layer.mask = maskLayer;
        return maskLayer
    }
    
    /// 高性能圆角
    public func drawCorners(_ radius: CGFloat, width: CGFloat, color: UIColor, bgColor: UIColor) {
        let image = drawCorners( .allCorners, radius: radius, width: width, color: color, bgColor: bgColor)
        let imgView = UIImageView(image: image)
        insertSubview(imgView, at: 0)
    }
    
    /// [源]高性能圆角
    public func drawCorners(_ corners: UIRectCorner = UIRectCorner.allCorners,
                           radius: CGFloat,
                           width: CGFloat,
                           color: UIColor,
                           bgColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.setLineWidth(width)
        ctx?.setStrokeColor(color.cgColor)
        ctx?.setFillColor(bgColor.cgColor)
        
        let halfBorderWidth = width/2.0
        let point0 = CGPointMake(bounds.width - halfBorderWidth, radius + halfBorderWidth)
        let point1 = CGPointMake(bounds.width - halfBorderWidth, bounds.height - halfBorderWidth)
        let point2 = CGPointMake(bounds.width - radius - halfBorderWidth, bounds.height - halfBorderWidth)
        let point3 = CGPointMake(halfBorderWidth, halfBorderWidth)
        let point4 = CGPointMake(bounds.width - halfBorderWidth, halfBorderWidth)
        let point5 = CGPointMake(bounds.width - halfBorderWidth, halfBorderWidth)
        let point6 = CGPointMake(bounds.width - halfBorderWidth, radius + halfBorderWidth)
        
        ctx?.move(to: point0)
        ctx?.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        ctx?.addArc(tangent1End: point3, tangent2End: point4, radius: radius)
        ctx?.addArc(tangent1End: point5, tangent2End: point6, radius: radius)
    
        ctx?.drawPath(using: .fillStroke)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func addCornerAll() -> CAShapeLayer {
        let cornerRadii = CGSize(width: bounds.width*0.5, height: bounds.height*0.5)
        return addCorners( .allCorners, cornerRadii: cornerRadii, width: 1.0, color: .white)
    }
   
    //MARK: -通用响应添加方法
    public func addActionClosure(_ action: @escaping ViewClosure) {
        if let sender = self as? UIButton {
            sender.addActionHandler({ (control) in
                action(nil, control, control.tag);

            }, for: .touchUpInside)
            
        }
        else if let sender = self as? UIControl {
            sender.addActionHandler({ (control) in
                action(nil, control, control.tag);

            }, for: .valueChanged)
            
        } else {
            _ = self.addGestureTap { (reco) in
                action((reco as! UITapGestureRecognizer), reco.view!, reco.view!.tag);
            }
        }
    }
    
/*
    //MARK: -通用响应添加方法
    public func addActionClosure(_ action: @escaping (ViewClosure)) {
        if let sender = self as? UIButton {
            sender.addTarget(self, action:#selector(p_handleActionSender(_:)), for:.touchUpInside);

        }
        else if let sender = self as? UIControl {
            sender.addTarget(self, action:#selector(p_handleActionSender(_:)), for:.valueChanged);

        } else {
//            let recoginzer = objc_getAssociatedObject(self, RuntimeKey.tap);
            var obj = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!);
            if obj == nil {
                obj = UITapGestureRecognizer(target: self, action: #selector(p_handleActionTap(_:)));
                isUserInteractionEnabled = true;
                addGestureRecognizer(obj! as! UIGestureRecognizer);
            }
        }
//        objc_setAssociatedObject(self, RuntimeKey.tap, action, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!, action, .OBJC_ASSOCIATION_COPY_NONATOMIC);
    }

    /// 点击回调
    private func p_handleActionTap(_ tap: UITapGestureRecognizer) {
//       let block = objc_getAssociatedObject(self, RuntimeKey.tap) as? ViewClosure;
        let block = objc_getAssociatedObject(self, UnsafeRawPointer(bitPattern: self.hashValue)!) as? ViewClosure;
        if block != nil{
            block!(tap, tap.view!, tap.view!.tag);
        }
    }

    private func p_handleActionSender(_ sender: UIControl) {
        let block = objc_getAssociatedObject(self, RuntimeKey.tap) as? ViewClosure;
        if let sender = self as? UISegmentedControl {
            if block != nil {
                block!(nil, sender, sender.selectedSegmentIndex);
            }

        } else {
            if block != nil {
                block!(nil, sender, sender.tag);
            }
        }
    }
*/
    
    ///手势 - 轻点 UITapGestureRecognizer
    public func addGestureTap(_ action: @escaping RecognizerClosure) -> UITapGestureRecognizer {
        let obj = UITapGestureRecognizer(target: nil, action: nil)
        obj.numberOfTapsRequired = 1  //轻点次数
        obj.numberOfTouchesRequired = 1  //手指个数

        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)

        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
    
    ///手势 - 长按 UILongPressGestureRecognizer
    public func addGestureLongPress(_ action: @escaping RecognizerClosure, for minimumPressDuration: TimeInterval) -> UILongPressGestureRecognizer {
        let obj = UILongPressGestureRecognizer(target: nil, action: nil)
        obj.minimumPressDuration = minimumPressDuration;
      
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
      
    ///手势 - 拖拽 UIPanGestureRecognizer
    public func addGesturePan(_ action: @escaping RecognizerClosure) -> UIPanGestureRecognizer {
        let obj = UIPanGestureRecognizer(target: nil, action: nil)
          //最大最小的手势触摸次数
        obj.minimumNumberOfTouches = 1
        obj.maximumNumberOfTouches = 3
          
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
          
        obj.addAction { (recognizer) in
            if let sender = recognizer as? UIPanGestureRecognizer {
                let translate:CGPoint = sender.translation(in: sender.view?.superview)
                sender.view!.center = CGPoint(x: sender.view!.center.x + translate.x, y: sender.view!.center.y + translate.y)
                sender.setTranslation( .zero, in: sender.view!.superview)
                             
                action(recognizer)
            }
        }
        return obj
    }
      
    ///手势 - 屏幕边缘 UIScreenEdgePanGestureRecognizer
    public func addGestureEdgPan(_ action: @escaping RecognizerClosure, for edgs: UIRectEdge) -> UIScreenEdgePanGestureRecognizer {
        let obj = UIScreenEdgePanGestureRecognizer(target: nil, action: nil)
        obj.edges = edgs
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
       
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
      
    ///手势 - 清扫 UISwipeGestureRecognizer
    public func addGestureSwip(_ action: @escaping RecognizerClosure, for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let obj = UISwipeGestureRecognizer(target: nil, action: nil)
        obj.direction = direction
      
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            action(recognizer)
        }
        return obj
    }
      
    ///手势 - 捏合 UIPinchGestureRecognizer
    public func addGesturePinch(_ action: @escaping RecognizerClosure) -> UIPinchGestureRecognizer {
        let obj = UIPinchGestureRecognizer(target: nil, action: nil)
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            if let sender = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: sender.view!.superview)
                sender.view!.center = location;
                sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
                action(recognizer)
            }
        }
        return obj
    }
      
    ///手势 - 旋转 UIRotationGestureRecognizer
    public func addGestureRotation(_ action: @escaping RecognizerClosure) -> UIRotationGestureRecognizer {
        let obj = UIRotationGestureRecognizer(target: nil, action: nil)
        isUserInteractionEnabled = true
        isMultipleTouchEnabled = true
        addGestureRecognizer(obj)
      
        obj.addAction { (recognizer) in
            if let sender = recognizer as? UIRotationGestureRecognizer {
                sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
                sender.rotation = 0.0;
                          
                action(recognizer)
            }
        }
        return obj
    }
/*
    //MARK: -手势
    ///手势 - 轻点
    public func addGestureTap(_ action: @escaping RecognizerClosure) -> UITapGestureRecognizer {
        let funcAbount = NSStringFromSelector(#function)
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        var obj = objc_getAssociatedObject(self, runtimeKey) as? UITapGestureRecognizer
        if obj == nil {
            obj = UITapGestureRecognizer(target: self, action: #selector(p_handleActionGesture(_:)))
            obj!.numberOfTapsRequired = 1  //轻点次数
            obj!.numberOfTouchesRequired = 1  //手指个数
            
            isUserInteractionEnabled = true
            isMultipleTouchEnabled = true
            addGestureRecognizer(obj!)

            obj!.runtimeKey = runtimeKey
            objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        return obj!
    }
  
    ///手势 - 长按
    public func addGestureLongPress(_ action: @escaping RecognizerClosure, for minimumPressDuration: TimeInterval) -> UILongPressGestureRecognizer {
        let funcAbount = NSStringFromSelector(#function) + ",\(minimumPressDuration)"
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        var obj = objc_getAssociatedObject(self, runtimeKey) as? UILongPressGestureRecognizer
        if obj == nil {
            obj = UILongPressGestureRecognizer(target: self, action: #selector(p_handleActionGesture(_:)))
            obj!.minimumPressDuration = minimumPressDuration;
            
            isUserInteractionEnabled = true
            isMultipleTouchEnabled = true
            addGestureRecognizer(obj!)
            
            obj!.runtimeKey = runtimeKey
            objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        return obj!
    }
    
    ///手势 - 拖拽
    public func addGesturePan(_ action: @escaping RecognizerClosure) -> UIPanGestureRecognizer {
        let funcAbount = NSStringFromSelector(#function)
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        var obj = objc_getAssociatedObject(self, runtimeKey) as? UIPanGestureRecognizer
        if obj == nil {
            obj = UIPanGestureRecognizer(target: self, action: #selector(p_handleActionGesture(_:)))
            //最大最小的手势触摸次数
            obj!.minimumNumberOfTouches = 1
            obj!.maximumNumberOfTouches = 3
            isUserInteractionEnabled = true
            isMultipleTouchEnabled = true
            addGestureRecognizer(obj!)
            
            obj!.runtimeKey = runtimeKey
            objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        return obj!
    }
    
    ///手势 - 屏幕边缘
    public func addGestureEdgPan(_ action: @escaping RecognizerClosure, for edgs: UIRectEdge) -> UIScreenEdgePanGestureRecognizer {
        let funcAbount = NSStringFromSelector(#function) + ",\(edgs)"
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        var obj = objc_getAssociatedObject(self, runtimeKey) as? UIScreenEdgePanGestureRecognizer
        if obj == nil {
            obj = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(p_handleActionGesture(_:)))
            obj!.edges = edgs
            isUserInteractionEnabled = true
            isMultipleTouchEnabled = true
            addGestureRecognizer(obj!)
            
            obj!.runtimeKey = runtimeKey
            objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        return obj!
    }
    
    ///手势 - 清扫
    public func addGestureSwip(_ action: @escaping RecognizerClosure, for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let funcAbount = NSStringFromSelector(#function) + ",\(direction)"
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        var obj = objc_getAssociatedObject(self, runtimeKey) as? UISwipeGestureRecognizer
        if obj == nil {
            obj = UISwipeGestureRecognizer(target: self, action: #selector(p_handleActionGesture(_:)))
            obj!.direction = direction
            
            isUserInteractionEnabled = true
            isMultipleTouchEnabled = true
            addGestureRecognizer(obj!)
            
            obj!.runtimeKey = runtimeKey
            objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        return obj!
    }
    
    ///手势 - 捏合
    public func addGesturePinch(_ action: @escaping RecognizerClosure) -> UIPinchGestureRecognizer {
        let funcAbount = NSStringFromSelector(#function)
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        var obj = objc_getAssociatedObject(self, runtimeKey) as? UIPinchGestureRecognizer
        if obj == nil {
            obj = UIPinchGestureRecognizer(target: self, action: #selector(p_handleActionGesture(_:)))
            
            isUserInteractionEnabled = true
            isMultipleTouchEnabled = true
            addGestureRecognizer(obj!)
        
            obj!.runtimeKey = runtimeKey
            objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        return obj!
    }
    
    ///手势 - 旋转
    public func addGestureRotation(_ action: @escaping RecognizerClosure) -> UIRotationGestureRecognizer {
        let funcAbount = NSStringFromSelector(#function)
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        var obj = objc_getAssociatedObject(self, runtimeKey) as? UIRotationGestureRecognizer
        if obj == nil {
            obj = UIRotationGestureRecognizer(target: self, action: #selector(p_handleActionGesture(_:)))
            
            isUserInteractionEnabled = true
            isMultipleTouchEnabled = true
            addGestureRecognizer(obj!)
            
            obj!.runtimeKey = runtimeKey
            objc_setAssociatedObject(self, runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        return obj!
    }
    
    private func p_handleActionGesture(_ recognizer: UIGestureRecognizer) {
    
        let block = objc_getAssociatedObject(self, recognizer.runtimeKey) as? RecognizerClosure;
//        DDLog(recognizer.funcName,block)
        switch recognizer {
        case is UISwipeGestureRecognizer:
//            print(recognizer)
            if block != nil {
                block!(recognizer)
            }
            
        case is UIScreenEdgePanGestureRecognizer:
//            print(recognizer)
            if block != nil {
                block!(recognizer)
            }
            
        case is UITapGestureRecognizer:
//            print(recognizer)
            if block != nil {
                block!(recognizer)
            }
            
        case is UILongPressGestureRecognizer:
//            print(recognizer)
            if recognizer.state == .began {
                if block != nil {
                    block!(recognizer)
                }
            }
            
        case is UIPanGestureRecognizer:
            if let sender = recognizer as? UIPanGestureRecognizer {
                let translate:CGPoint = sender.translation(in: sender.view?.superview)
                sender.view!.center = CGPoint(x: recognizer.view!.center.x + translate.x, y: recognizer.view!.center.y + translate.y)
                sender.setTranslation( .zero, in: recognizer.view!.superview)
                
                if block != nil {
                    block!(recognizer)
                }
            }
            
        case is UIPinchGestureRecognizer:
            if let sender = recognizer as? UIPinchGestureRecognizer {
                let location = recognizer.location(in: sender.view!.superview)
                sender.view!.center = location;
                sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
                sender.scale = 1.0
                //            print(recognizer)
                if block != nil {
                    block!(recognizer)
                }
            }
           
        case is UIRotationGestureRecognizer:
            if let sender = recognizer as? UIRotationGestureRecognizer {
//                sender.view!.transform = CGAffineTransform(rotationAngle: sender.rotation)
                sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
                sender.rotation = 0.0;
                //            print(recognizer)
                if block != nil {
                    block!(recognizer)
                }
            }
            
        default:
            print("无法识别手势类型")
        }
    }
*/
    //MARK: -Cell
    public func getCell() -> UITableViewCell{
        var supView = superview
        while let view = supView as? UITableViewCell {
            supView = view.superview
        }
        return supView as! UITableViewCell;
    }
    
    public func getCellIndexPath(_ tableView: UITableView) -> IndexPath{
        let cell = self.getCell();
        return tableView.indexPathForRow(at: cell.center)!
    }
    
    public func convertToImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        self.layer.render(in: ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!;
    }
        
    /// 保存图像到相册
    public func imageToSavedPhotosAlbum(_ action: @escaping((NSError?) -> Void)) {
        var image: UIImage = self.convertToImage();
        if let imgView = self as? UIImageView {
            if imgView.image != nil {
                image = imgView.image!
            }
        }
        //保存相册
        image.toSavedPhotoAlbum { (error) in
            action(error)
        }
    }
    /// 获取父视图的 UIScrollView
    public func supScrollView() -> UIScrollView? {
        var supView = self.superview
        while supView?.isKind(of: UIScrollView.classForCoder()) == false {
            supView = supView?.superview;
        }
        
        if supView?.isKind(of: UIWindow.classForCoder()) == true {
            return nil
        }
        return (supView as! UIScrollView)
    }
    
    /// 插入模糊背景
    public func insertVisualEffectView() -> UIVisualEffectView {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.frame = self.bounds
        self.insertSubview(effectView, at: 0)
        return effectView;
    }
    
    /// 验证码倒计时显示
    public static func GCDTimerStart(_ lab: UILabel!, _ interval: Int = 60) {
        var time = interval
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {
            
            time -= 1
            DispatchQueue.main.async {
                lab.isEnabled = time <= 0;
                if time > 0 {
                    lab.text = "剩余\(time)s";
                    return;
                }
                codeTimer.cancel()
                lab.text = "发送验证码";
            }
        }
        codeTimer.resume()
//        codeTimer.activate()
    }
//    /// 计时显示
//    public static func GCDTimerAdd(_ lab: UILabel!, _ length: Int = 5, date: NSDate = NSDate(), step: Int = 1) -> DispatchSourceTimer{
//
//        var time = 0;
//        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
//        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
//        codeTimer.setEventHandler {
//            
//            time += step;
//            DispatchQueue.main.async {
//                lab.isEnabled = time <= 0;
//                if time > 0 {
//                    lab.text = "\(date.agoInfo(1, length: lab.text!.count))"
//                    return;
//                }
//                codeTimer.cancel()
//                lab.text = "00:00:00".substringFrom(8-length)
//            }
//        }
//        codeTimer.resume()
////        codeTimer.activate()
//        return codeTimer;
//    }

}
