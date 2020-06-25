//
//  UIButton+Ext.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/25.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Ext)

- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
