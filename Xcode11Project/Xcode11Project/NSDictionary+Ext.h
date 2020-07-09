//
//  NSDictionary+Ext.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/3.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<KeyType, ObjectType> (Ext)
/**
map 高阶函数
*/
- (NSDictionary *)map:(NSDictionary *(NS_NOESCAPE ^)(KeyType key, ObjectType obj))block;
/**
filter 高阶函数
*/
- (NSDictionary *)filter:(BOOL (NS_NOESCAPE ^)(KeyType key, ObjectType obj))block;
/**
compactMapValues 高阶函数
*/
- (NSDictionary *)compactMapValues:(id (NS_NOESCAPE ^)(ObjectType obj))block;

@end

NS_ASSUME_NONNULL_END
