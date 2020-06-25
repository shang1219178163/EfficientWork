//
//  UIButton+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/25.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "UIButton+Ext.h"
#import "UIImage+Ext.h"

@implementation UIButton (Ext)

- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state{
    if (color == nil) {
        return;
    }
    UIImage *image = [UIImage imageWithColor:color];
    [self setBackgroundImage:image forState:state];
}

@end
