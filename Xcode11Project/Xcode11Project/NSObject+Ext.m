//
//  NSObject+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/4.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "NSObject+Ext.h"

@implementation NSObject (Ext)

- (void)enumerateIvars:(void(^)(Ivar v, NSString *name, _Nullable id value))block{
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self.class, &count);

    for(NSInteger i = 0; i < count; i++){
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:ivarName];//kvc读值
        if (block) {
            block(ivar, ivarName, value);
        }
    }
    free(ivars);
}

- (void)enumeratePropertys:(void(^)(objc_property_t property, NSString *name, _Nullable id value))block{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property_t = properties[i];
        const char *name = property_getName(property_t);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (block) {
            block(property_t, propertyName, value);
        }
    }
    free(properties);
}

- (void)enumerateMethods:(void(^)(Method method, NSString *name))block{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(self.class, &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methodList[i];
        SEL mthodName = method_getName(method);
//        NSLog(@"MethodName(%d): %@", i, NSStringFromSelector(mthodName));
        if (block) {
            block(method, NSStringFromSelector(mthodName));
        }
    }
    free(methodList);
}

- (void)enumerateProtocols:(void(^)(Protocol *proto, NSString *name))block{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(self.class, &count);
    for (int i = 0; i < count; i++) {
        Protocol *protocal = protocolList[i];
        const char *protocolName = protocol_getName(protocal);
//        NSLog(@"protocol(%d): %@", i, [NSString stringWithUTF8String:protocolName]);
        if (block) {
            block(protocal, [NSString stringWithUTF8String:protocolName]);
        }
    }
    free(protocolList);
}

@end
