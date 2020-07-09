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

@interface NSArray<ObjectType> (Ext)
/**
 map 高阶函数
 */
- (NSArray *)map:(id (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx))block;

/**
compactMap 高阶降维函数
*/
- (NSArray *)compactMap:(id (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx))block;

/**
 filter 高阶函数
 */
- (NSArray *)filter:(BOOL(NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx))block;

/**
 reduce 高阶函数(求和,累加等)
 */
- (NSNumber *)reduce:(NSNumber *)initial block:(NSNumber *(NS_NOESCAPE ^)(NSNumber *result, NSNumber *obj))block;

@end

NS_ASSUME_NONNULL_END
