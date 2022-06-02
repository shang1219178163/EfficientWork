iOS runtime 应用场景总结

场景1.动态分类关联属性
场景2.hook/Method Swizzling
场景3.遍历类属性方法，映射解析以及字典与模型的转换, 例如YYModel
场景4.修改isa指针（研究中）

场景5.利用runtime实现消息转发机制的补救

场景6.实现 NSCoding 的自动归档和解档
```
- (void)encodeWithCoder:(NSCoder *)aCoder {
    // 一个临时数据, 用来记录一个类成员变量的个数
    unsigned int ivarCount = 0;
    // 获取一个类所有的成员变量
    Ivar *ivars = class_copyIvarList(self.class, &ivarCount);
    
    // 变量成员变量列表
    for (int i = 0; i < ivarCount; i ++) {
        // 获取单个成员变量
        Ivar ivar = ivars[i];
        // 获取成员变量的名字并将其转换为 OC 字符串
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取该成员变量对应的值
        id value = [self valueForKey:ivarName];
        // 归档, 就是把对象 key-value 对 encode
        [aCoder encodeObject:value forKey:ivarName];
    }
    // 释放 ivars
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    // 因为没有 superClass 了
    self = [self init];
    if (self != nil) {
        unsigned int ivarCount = 0;
        Ivar *ivars = class_copyIvarList(self.class, &ivarCount);
        for (int i = 0; i < ivarCount; i ++) {
            
            Ivar ivar = ivars[i];
            NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            // 解档, 就是把 key-value 对 decode
            id value = [aDecoder decodeObjectForKey:ivarName];
            // 赋值
            [self setValue:value forKey:ivarName];
        }
        free(ivars);
    }
    return self;
}
```
场景7.分类重写 kvc 方法，防崩溃

```
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"setValue: forUndefinedKey:, 动态创建Key: %@",key);
    objc_setAssociatedObject(self, CFBridgingRetain(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(nullable id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"valueForUndefinedKey:, 获取未知键 %@ 的值", key);
//    return nil;
    return objc_getAssociatedObject(self, CFBridgingRetain(key));
}

-(void)setNilValueForKey:(NSString *)key{
    NSLog(@"Invoke setNilValueForKey:, 不能给非指针对象(如NSInteger)赋值 nil");
    return;//给一个非指针对象(如NSInteger)赋值 nil, 直接忽略
}
```
场景 8：获取类的成员变量，属性，方法，协议
```
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

- (void)enumerateMethods:(void(^)(Method method, NSString *name, NSInteger idx))block{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(self.class, &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methodList[i];
        SEL mthodName = method_getName(method);
//        NSLog(@"MethodName(%d): %@", i, NSStringFromSelector(mthodName));
        if (block) {
            block(method, NSStringFromSelector(mthodName), i);
        }
    }
    free(methodList);
}

- (void)enumerateProtocols:(void(^)(Protocol *proto, NSString *name, NSInteger idx))block{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(self.class, &count);
    for (int i = 0; i < count; i++) {
        Protocol *protocal = protocolList[i];
        const char *protocolName = protocol_getName(protocal);
//        NSLog(@"protocol(%d): %@", i, [NSString stringWithUTF8String:protocolName]);
        if (block) {
            block(protocal, [NSString stringWithUTF8String:protocolName], i);
        }
    }
    free(protocolList);
}
```
场景 9：动态获取 class，selector以及创建动态视图，极大地提高代码复用率
```
NSClassFromString(@"MyClass");
NSSelectorFromString(@"showShareActionSheet");
```