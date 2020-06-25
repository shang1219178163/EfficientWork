//
//  UILabel+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/1/4.
//

/*
 Range与NSRange区别很大
 */

import UIKit

@objc public extension UILabel{
    /// [源]UILabel创建
    static func create(_ rect: CGRect = .zero, textColor: UIColor = .black, type: Int = 0) -> Self {
        let view = self.init(frame: rect);
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isUserInteractionEnabled = true;
        view.textAlignment = .left;
        view.textColor = textColor
        view.font = UIFont.systemFont(ofSize: 15);
        
        switch type {
        case 1:
            view.numberOfLines = 1;
            view.lineBreakMode = .byTruncatingTail;
        // 一行文本自适应宽度调节
        case 2:
            view.numberOfLines = 1;
            view.lineBreakMode = .byTruncatingTail;
            view.adjustsFontSizeToFitWidth = true;
        // 红色带边框标签
        case 3:
            view.numberOfLines = 1;
            view.lineBreakMode = .byTruncatingTail;
            view.textAlignment = .center;
            view.textColor = textColor;
            
            view.layer.borderColor = view.textColor.cgColor;
            view.layer.borderWidth = 1.0;
            view.layer.masksToBounds = true;
            view.layer.cornerRadius = rect.width*0.5;
            
        // 红色带圆角边框
        case 4:
            view.numberOfLines = 1;
            view.lineBreakMode = .byTruncatingTail;
            view.textAlignment = .center;
            view.textColor = textColor;
            
            view.layer.borderColor = view.textColor.cgColor;
            view.layer.borderWidth = 1.0;
            view.layer.masksToBounds = true;
            view.layer.cornerRadius = 3;
            
        default:
            view.numberOfLines = 0;
            view.lineBreakMode = .byCharWrapping;
        }
        return view;
    }
    /// UILabel富文本设置
    func setContent(_ content: String, attDic: [NSAttributedString.Key: Any]) -> NSMutableAttributedString{
        assert((self.text?.contains(content))!)
        
        let text: NSString = self.text! as NSString
        let attString = NSMutableAttributedString(string: text as String)
        let range:NSRange = text.range(of: content)
        attString.addAttributes(attDic, range: range)
        attributedText = attString
        return attString
    }
    
    /// 验证码倒计时显示
    func timerStart(_ interval: Int = 60) {
        var time = interval
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {
            
            time -= 1
            DispatchQueue.main.async {
                self.isEnabled = time <= 0;
                if time > 0 {
                    self.text = "剩余\(time)s";
                    return;
                }
                codeTimer.cancel()
                self.text = "发送验证码";
            }
        }
        codeTimer.resume()
    }
}

@objc public extension UILabel{
        
//    func setupMenuItem(_ items: [UIMenuItem]) {
//        UIMenuController.shared.menuItems = items
//    }
    
    func addLongPressMenuItems() {
        isUserInteractionEnabled = true

        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleMenuItems(_:)));
        addGestureRecognizer(recognizer)
    }
    
    // MARK: -funtions
    @objc func handleMenuItems(_ recognizer: UIGestureRecognizer) {
        guard let recognizerView = recognizer.view,
              let recognizerSuperView = recognizerView.superview
          else { return }
   
        if #available(iOS 13.0, *) {
            UIMenuController.shared.showMenu(from: recognizerSuperView, rect: recognizerView.frame)

        } else {
            UIMenuController.shared.setTargetRect(recognizerView.frame, in: recognizerSuperView)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
        recognizerView.becomeFirstResponder()
    }
    
    // MARK: -edit menu
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard let menuItems = UIMenuController.shared.menuItems else { return [#selector(copy(_:))].contains(action)}
        let actions: [Selector] = menuItems.map { $0.action }
        return actions.contains(action)
    }
    
    // MARK: - UIResponderStandardEditActions
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    override func paste(_ sender: Any?) {
        text = UIPasteboard.general.string
    }
    
    override func delete(_ sender: Any?) {
        text = ""
    }
}
