//
//  NSArray+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/20.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "NSArray+Ext.h"

@implementation NSArray (Ext)


- (NSArray *)map:(id (^)(id obj, NSUInteger idx))handler{
    __block NSMutableArray *marr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            id blockResult = handler(obj, idx) ? : obj;
            [marr addObject:blockResult];
        }
    }];
//    DDLog(@"%@->%@", self, marr.copy);
    return marr.copy;
}

- (NSArray *)filter:(BOOL(^)(id obj, NSUInteger idx))handler{
    __block NSMutableArray *marr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler && handler(obj, idx) == true) {
            [marr addObject:obj];
        }
    }];
    return marr.copy;
}

- (NSNumber *)reduce:(NSNumber *(^)(NSNumber *num1, NSNumber *num2))handler{
    __block CGFloat result = 0.0;
    [self enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.count - 1) {
            NSNumber *num1 = idx == 0 ? obj : @(result);
            NSNumber *num2 = self[idx+1];
            if (handler) {
                result = handler(num1, num2).floatValue;
//                DDLog(@"handler_%@_%@_%@_%@",num1, num2, handler(num1, num2), @(result));
            }
        }
    }];
    return @(result);
}

@end
