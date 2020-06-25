//
//  UIImage+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/25.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "UIImage+Ext.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (Ext)

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen.scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
