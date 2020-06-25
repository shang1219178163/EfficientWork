//
//  NSArray+Ext.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/20.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Ext)
/**
 map 高阶函数(使用时需要将obj强转为数组元素类型)
 */
- (NSArray *)map:(id (^)(id obj, NSUInteger idx))handler;

/**
 filter 高阶函数(使用时需要将obj强转为数组元素类型)
 */
- (NSArray *)filter:(BOOL(^)(id obj, NSUInteger idx))handler;

/**
 reduce 高阶函数(求和,累加等)
 */
- (NSNumber *)reduce:(NSNumber *(^)(NSNumber *num1, NSNumber *num2))handler;

@end

NS_ASSUME_NONNULL_END
