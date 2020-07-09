//
//  NSArray+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/20.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "NSArray+Ext.h"

@implementation NSArray (Ext)

- (NSArray *)map:(id (NS_NOESCAPE ^)(id obj, NSUInteger idx))block{
    NSParameterAssert(block != nil);
    
    __block NSMutableArray *marr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block(obj, idx);
        if (value) {
            [marr addObject:value];
        }
    }];
//    DDLog(@"%@->%@", self, marr.copy);
    return marr.copy;
}

- (NSArray *)compactMap:(id (NS_NOESCAPE ^)(id obj, NSUInteger idx))block{
    NSParameterAssert(block != nil);

    __block NSMutableArray *marr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block(obj, idx) ? : obj;
        if ([value isKindOfClass:NSArray.class]) {
            [marr addObjectsFromArray:value];
        } else {
            [marr addObject:value];
        }
    }];
//    DDLog(@"%@->%@", self, marr.copy);
    return marr.copy;
}

- (NSArray *)filter:(BOOL(NS_NOESCAPE ^)(id obj, NSUInteger idx))block{
    NSParameterAssert(block != nil);

    __block NSMutableArray *marr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj, idx) == true) {
            [marr addObject:obj];
        }
    }];
    return marr.copy;
}

- (NSNumber *)reduce:(NSNumber *)initial block:(NSNumber *(NS_NOESCAPE ^)(NSNumber *result, NSNumber *obj))block{
    NSParameterAssert(block != nil);

    __block NSNumber *value = initial;
    [self enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        value = block(value, obj);
    }];
    return value;
}

@end
