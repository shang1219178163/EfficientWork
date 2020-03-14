//
//  UIImage+Helper.swift
//  SwiftTemplet
//
//  Created by dev on 2018/12/11.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

//MARK - UIImage
@objc public extension UIImage {
//    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
//        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
//        defer {
//            UIGraphicsEndImageContext()
//        }
//        let context = UIGraphicsGetCurrentContext()
//        context?.setFillColor(color.cgColor)
//        context?.fill(CGRect(origin: CGPoint.zero, size: size))
//        context?.setShouldAntialias(true)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        guard let cgImage = image?.cgImage else {
//            self.init()
//            return nil
//        }
//        self.init(cgImage: cgImage)
//    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func croppedImage(bound: CGRect) -> UIImage {
        let scaledBounds = CGRect(x:bound.origin.x * self.scale, y:bound.origin.y * self.scale, width:bound.size.width * self.scale, height:bound.size.height * self.scale)
        let imageRef = cgImage?.cropping(to:scaledBounds)
        let croppedImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: .up)
        
        return croppedImage
    }
    
    /// 保存UIImage对象到相册
    func toSavedPhotoAlbum(_ action: @escaping((NSError?) -> Void)) {
        let funcAbount = NSStringFromSelector(#function)
        let runtimeKey = RuntimeKeyFromParams(self, funcAbount: funcAbount)!
        
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        self.runtimeKey = runtimeKey;
        
        let obj = objc_getAssociatedObject(self, self.runtimeKey)
        if obj == nil {
            objc_setAssociatedObject(self, self.runtimeKey, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        let obj = objc_getAssociatedObject(self, image.runtimeKey) as? ((NSError?) -> Void)
        if obj != nil {
            obj!(error)
        }
    }
    
    /// 二维码
    static func generateQRImage(QRCodeString: String, logo: UIImage?, size: CGSize = CGSize(width: 50, height: 50)) -> UIImage? {
        guard let data = QRCodeString.data(using: .utf8, allowLossyConversion: false) else {
            return nil
        }
        let imageFilter = CIFilter(name: "CIQRCodeGenerator")
        imageFilter?.setValue(data, forKey: "inputMessage")
        imageFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let ciImage = imageFilter?.outputImage
        
        // 创建颜色滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        // 返回二维码图片
        let qrImage = UIImage(ciImage: (colorFilter?.outputImage)!)
        let imageRect = size.width > size.height ?
            CGRect(x: (size.width - size.height) / 2, y: 0, width: size.height, height: size.height) :
            CGRect(x: 0, y: (size.height - size.width) / 2, width: size.width, height: size.width)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        qrImage.draw(in: imageRect)
        if logo != nil {
            let logoSize = size.width > size.height ?
                CGSize(width: size.height * 0.25, height: size.height * 0.25) :
                CGSize(width: size.width * 0.25, height: size.width * 0.25)
            logo?.draw(in: CGRect(x: (imageRect.size.width - logoSize.width) / 2, y: (imageRect.size.height - logoSize.height) / 2, width: logoSize.width, height: logoSize.height))
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 切圆角图片
    func roundImage(byRoundingCorners: UIRectCorner = .allCorners, cornerRadii: CGSize = CGSize(width: 5, height: 5)) -> UIImage? {
        
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: byRoundingCorners,
                                      cornerRadii: cornerRadii)
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 根据最大尺寸限制压缩图片
    static func compressData(_ image: UIImage, limit: Int = 1024*2) -> Data {
        var compression: CGFloat = 1.0;
        let maxCompression: CGFloat = 0.1;
        
        var imageData = image.jpegData(compressionQuality: compression)
        while imageData!.count > limit && compression > maxCompression {
            compression -= 0.1;
            imageData = image.jpegData(compressionQuality: compression)
        }
        return imageData!;
    }
    
    /// 获取图片data的类型
    static func contentType(_ imageData: NSData) -> String {
        var type: String = "jpg";
        
        var c: UInt8?
        imageData.getBytes(&c, length: 1)
        switch c {
        case 0xFF:
            type = "jpeg";
        case 0x89:
            type = "png";
        case 0x47:
            type = "gif";
        case 0x49,0x4D:
            type = "tiff";
        case 0x42:
            type = "bmp";
        case 0x52:
            if (imageData.count < 12) {
                type = "none";
            }
            let string: NSString = NSString(data: imageData.subdata(with: NSMakeRange(0, 12)), encoding: String.Encoding.ascii.rawValue)!
            if string.hasPrefix("RIFF"),string.hasSuffix("WEBP") {
                type = "webp"
            }
        default:
            type = "jpg";
        }
        return type;
    }
}
