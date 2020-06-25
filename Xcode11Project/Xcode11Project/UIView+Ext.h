//
//  UIView+Ext.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/25.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Ext)

- (NSArray<__kindof UIView *> *)updateItems:(NSInteger)count aClassName:(NSString *)aClassName handler:(void(^)(__kindof UIView *obj))handler;

- (NSArray<__kindof UIButton *> *)updateButtonItems:(NSInteger)count aClassName:(NSString *)aClassName handler:(void(^)(__kindof UIButton *obj))handler;

@end

NS_ASSUME_NONNULL_END
