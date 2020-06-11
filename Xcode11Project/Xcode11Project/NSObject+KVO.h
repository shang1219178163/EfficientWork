//
//  NSObject+KVO.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/11.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KVOBlock)(NSString *keyPath, NSDictionary<NSKeyValueChangeKey,id> *change);
typedef void(^KVODeallocBlock)(void);

@interface NSObject (KVO)

///KVO block 封装
- (void)addKVOObserver:(NSObject *)object keyPath:(NSString *)keyPath block:(KVOBlock)block;

@end

NS_ASSUME_NONNULL_END
