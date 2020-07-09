//
//  NSObject+Ext.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/4.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Ext)

///遍历成员变量列表
- (void)enumerateIvars:(void(^)(Ivar v, NSString *name, _Nullable id value))block;
///遍历属性列表
- (void)enumeratePropertys:(void(^)(objc_property_t property, NSString *name, _Nullable id value))block;
///遍历方法列表(不含类方法)
- (void)enumerateMethods:(void(^)(Method method, NSString *name))block;
///遍历遵循的协议列表
- (void)enumerateProtocols:(void(^)(Protocol *proto, NSString *name))block;

@end

NS_ASSUME_NONNULL_END
