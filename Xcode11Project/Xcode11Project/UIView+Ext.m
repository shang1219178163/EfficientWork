//
//  UIView+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/25.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "UIView+Ext.h"
#import "NSArray+Ext.h"

@implementation UIView (Ext)

- (NSArray<__kindof UIView *> *)updateItems:(NSInteger)count aClassName:(NSString *)aClassName handler:(void(^)(__kindof UIView *obj))handler {
    Class cls = NSClassFromString(aClassName);
    NSArray *list = [self.subviews filter:^BOOL(UIView * obj, NSUInteger idx) {
        return [obj isKindOfClass:cls.class];
    }];
    
    if (list.count == count) {
        return list;
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray *marr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        UIView *subview = [[cls alloc]init];
        subview.tag = i;
        
        [self addSubview:subview];
        [marr addObject:subview];
        if (handler) {
            handler(subview);
        }
    }
    return marr;
}

- (NSArray<__kindof UIButton *> *)updateButtonItems:(NSInteger)count aClassName:(NSString *)aClassName handler:(void(^)(__kindof UIButton *obj))handler {
    return [self updateItems:count aClassName:aClassName handler:^(__kindof UIView * _Nonnull obj) {
        if (![obj isKindOfClass:UIButton.class]) {
            return;
        }
//        NSString *clsName = NSStringFromClass(obj.class);
        UIButton *sender = (UIButton *)obj;
        sender.titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *title = [NSString stringWithFormat:@"%@%@", aClassName, @(obj.tag)];
        [sender setTitle:title forState:UIControlStateNormal];
        [sender setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        if (handler) {
            handler(obj);
        }
    }];
}


@end
