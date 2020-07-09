//
//  RuntimeViewController.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/4.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "RuntimeViewController.h"
#import "NSObject+Ext.h"
#import "NSNull+Safe.h"

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self enumerateMethods:^(Method  _Nonnull method, NSString * _Nonnull name) {
        NSLog(@"%@ %@", NSStringFromSelector(_cmd), name);
    }];
 
    [self runtimeFunc];
    
    UILabel *label = UILabel.alloc.init;
    label.text = NSNull.null;
    
}


+ (void)funcq {
    
}

- (void)runtimeFunc {
//    struct objc_object {
//        Class isa;
//    }
//    typedef struct objc_object *id;
//
//    typedef struct objc_class *Class;
//    struct objc_class {
//     Class isa                                 OBJC_ISA_AVAILABILITY; // metaclass
//    #if !__OBJC2__
//     Class super_class                         OBJC2_UNAVAILABLE; // 父类
//     const char *name                          OBJC2_UNAVAILABLE; // 类名
//     long version                              OBJC2_UNAVAILABLE; // 类的版本信息，默认为0，可以通过runtime函数class_setVersion或者class_getVersion进行修改、读取
//     long info                                 OBJC2_UNAVAILABLE; // 类信息，供运行时期使用的一些位标识，如CLS_CLASS (0x1L) 表示该类为普通 class，其中包含实例方法和变量;CLS_META (0x2L) 表示该类为 metaclass，其中包含类方法;
//     long instance_size                        OBJC2_UNAVAILABLE; // 该类的实例变量大小（包括从父类继承下来的实例变量）
//     struct objc_ivar_list *ivars              OBJC2_UNAVAILABLE; // 该类的成员变量地址列表
//     struct objc_method_list **methodLists     OBJC2_UNAVAILABLE; // 方法地址列表，与 info 的一些标志位有关，如CLS_CLASS (0x1L)，则存储实例方法，如CLS_META (0x2L)，则存储类方法;
//     struct objc_cache *cache                  OBJC2_UNAVAILABLE; // 缓存最近使用的方法地址，用于提升效率；
//     struct objc_protocol_list *protocols      OBJC2_UNAVAILABLE; // 存储该类声明遵守的协议的列表
//    #endif
//    }
    /* Use `Class` instead of `struct objc_class *` */
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    Method *methodList = class_copyMethodList(self.class, &count);
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(self.class, &count);

    class_getVersion(self.class);
    object_getClassName(self.class);
    
    Class class = objc_getMetaClass(@"NSString");
}

@end
