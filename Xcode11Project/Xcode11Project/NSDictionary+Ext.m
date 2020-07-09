//
//  NSDictionary+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/3.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "NSDictionary+Ext.h"

@implementation NSDictionary (Ext)

- (NSDictionary *)map:(NSDictionary *(NS_NOESCAPE ^)(id key, id obj))block{
    __block NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block) {
            NSDictionary *blockResult = block(key, obj);
            if (blockResult) {
                [mdic addEntriesFromDictionary:blockResult];
            }
        }
    }];
    return mdic.copy;
}

- (NSDictionary *)filter:(BOOL (NS_NOESCAPE ^)(id key, id obj))block{
    __block NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
     [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
         if (block && block(key, obj) == true) {
             [mdic setObject:obj forKey:key];
         }
     }];
    return mdic.copy;
}

- (NSDictionary *)compactMapValues:(id (NS_NOESCAPE ^)(id obj))block{
    __block NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block) {
            id blockResult = block(obj);
            if (blockResult) {
                mdic[key] = blockResult;
            }
        }
    }];
    return mdic.copy;
}


@end
