【转载加链接，谢谢合作！】

需求逻辑  =》函数/方法 =》通用函数/方法 =》高阶函数

对特定需求逻辑实现为函数/方法，对相似需求逻辑进行抽象为通用函数/方法，对通用函数/方法进行二次抽象为高阶函数，可以理解为函数的抽象函数。本质上并不复杂，关键是要彻底想透每一个细节，任何一个参数类型都会极大的影响其适用性。（抽象层次越高，适用范围越广，具体使用越复杂[可通过语言层面例如泛型进行优化]，函数封装需要同时兼顾适用性和使用便利性。）

```
NS_ASSUME_NONNULL_BEGIN
@interface NSArray (Helper)

/**
 map 高阶函数(使用时需要将obj强转为数组元素类型)
 */
- (NSArray<NSObject *> *)map:(NSObject *(^)(NSObject *obj, NSUInteger idx))handler;
/**
 filter 高阶函数(使用时需要将obj强转为数组元素类型)
 */
- (NSArray *)filter:(BOOL(^)(NSObject *obj, NSUInteger idx))handler;

/**
 reduce 高阶函数(求和,累加等)
 */
- (NSNumber *)reduce:(NSNumber *(^)(NSNumber *num1, NSNumber *num2))handler;

@implementation NSArray (Helper)

- (NSArray<NSObject *> *)map:(NSObject *(^)(NSObject *obj, NSUInteger idx))handler{
    __block NSMutableArray *marr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(NSObject *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            NSObject * blockResult = handler(obj, idx) ? : obj;
            [marr addObject:blockResult];
        }
    }];
    return marr.copy;
}

- (NSArray *)filter:(BOOL(^)(NSObject *obj, NSUInteger idx))handler{
    __block NSMutableArray *marr = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(NSObject *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler && handler(obj, idx) == true) {
            [marr addObject:obj];
        }
    }];
    return marr.copy;
}

- (NSNumber *)reduce:(NSNumber *(^)(NSNumber *num1, NSNumber *num2))handler{
    __block CGFloat result = 0.0;
    [self enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.count - 1) {
            NSNumber *num1 = idx == 0 ? obj : @(result);
            NSNumber *num2 = self[idx+1];
            if (handler) {
                result = handler(num1, num2).floatValue;
//                DDLog(@"handler_%@_%@_%@_%@",num1, num2, handler(num1, num2), @(result));
            }
        }
    }];
    return @(result);
}

🌰🌰🌰：
    1. 截取子字符串
    NSArray *list = @[@"1111", @"2222", @"3333", @"4444"];
    NSArray *listOne = [list map:^NSObject * _Nonnull(NSObject * _Nonnull obj, NSUInteger idx) {
        return [(NSString *)obj substringToIndex:idx];
    }];
    // listOne_(, 2, 33, 444,)
    
    2. 抽取模型数组对应属性
    NSMutableArray * marr = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        WHKNetInfoFeedModel * model = [[WHKNetInfoFeedModel alloc]init];
        model.category = [NSString stringWithFormat:@"name_%@", @(i)];
        model.vendor = [NSDateFormatter stringFromDate:NSDate.date format:kFormatDate];
        [marr addObject:model];
    }
    
    NSArray * listTwo = [marr map:^NSObject * _Nonnull(NSObject * _Nonnull obj, NSUInteger idx) {
        return [obj valueForKey:@"category"] ? : @"";
    }];
    //  listTwo_( name_0, name_1, name_2, name_3, name_4, )

    3.修改数组模型属性值
     NSArray * listThree = [marr map:^NSObject * _Nonnull(NSObject * _Nonnull obj, NSUInteger idx) {
        [obj setValue:@(idx) forKey:@"category"];
        return obj;
    }];
    //  listThree_(model.category = @(0), model.category = @(1), model.category = @(2), model.category = @(3), model.category = @(4));

    4. 过滤大约@“222”的元素
    NSArray *listTwo = [list filter:^BOOL(NSObject * _Nonnull obj, NSUInteger idx) {
        return [(NSString *)obj compare:@"222" options:NSNumericSearch] == NSOrderedDescending;
    }];
    // listTwo_( 333, 444, )

    5. 过滤不等于@“222”的元素
    NSArray *list2 = [list filter:^BOOL(NSObject * _Nonnull obj, NSUInteger idx) {
        return (![(NSString *)obj isEqualToString:@"222"]);
    }];
    //  list2_(111,333,444,)
    
    6. array = @[@1, @3, @5, @7, @9];
    NSNumber * result = [array reduce:^NSNumber *(NSNumber * _Nonnull num1, NSNumber * _Nonnull num2) {
        return @(num1.floatValue * 10 + num2.floatValue);
    }];
   // result_13579
    
    7.NSNumber * result1 = [array reduce:^NSNumber *(NSNumber * _Nonnull num1, NSNumber * _Nonnull num2) {
        return @(num1.floatValue + num2.floatValue);
    }];
    // result1_25    
```
```
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary(Helper)

- (NSDictionary<NSObject<NSCopying> *, NSObject *> *)map:(NSObject *(^)(NSObject<NSCopying> *key, NSObject *obj))handler;

- (nullable NSDictionary<NSObject<NSCopying> *, NSObject *> *)filter:(BOOL(^)(NSObject<NSCopying> *key, NSObject *obj))handler;

@end

@implementation NSDictionary(Tmp)

- (NSDictionary<NSObject<NSCopying> *, NSObject *> *)map:(NSObject *(^)(NSObject<NSCopying> *key, NSObject *obj))handler{
    __block NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(NSObject<NSCopying> * _Nonnull key, NSObject * _Nonnull obj, BOOL * _Nonnull stop) {
        NSObject *blockResult = handler(key, obj) ? : obj;
        [mdic setObject:blockResult forKey:key];
    }];
    return mdic.copy;
}

- (nullable NSDictionary<NSObject<NSCopying> *, NSObject *> *)filter:(BOOL(^)(NSObject<NSCopying> *key, NSObject *obj))handler{
    __block NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
     [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
         if (handler && handler(key, obj) == true) {
             [mdic setObject:obj forKey:key];
         }
     }];
    return mdic.copy;
}

🌰🌰🌰：
 NSDictionary *dic = @{
                          @"1": @"111",
                          @"2": @"222",
                          @"3": @"222",
                          @"4": @"444",
                          };
    1.对 value 加工
    NSDictionary *dic1 = [dic map:^NSObject * _Nonnull(NSObject<NSCopying> * _Nonnull key, NSObject * _Nonnull obj) {
        return [NSString stringWithFormat:@"%@_%@", key, obj];
    }];
    DDLog(@"dic1_%@",dic1);
//    2019-08-26 18:54:36.503000+0800【line -303】-[TestViewController funtionMoreDic] dic1_{
//        3 = 3_222;
//        1 = 1_111;
//        4 = 4_444;
//        2 = 2_222;
//    }

    2. 过滤键等于@“2”的子字典
    NSDictionary *dic2 = [dic filter:^BOOL(NSObject<NSCopying> * _Nonnull key, NSObject * _Nonnull obj) {
        return [(NSString *)key isEqualToString:@"2"];
    }];
    DDLog(@"dic2_%@",dic2);
//    2019-08-26 18:54:36.504000+0800【line -304】-[TestViewController funtionMoreDic] dic2_{
//        2 = 222;
//    }

    3. 过滤值为@“222” 的子字典
    NSDictionary *dic3 = [dic filter:^BOOL(NSObject<NSCopying> * _Nonnull key, NSObject * _Nonnull obj) {
        return [(NSString *)obj isEqualToString:@"222"];
    }];
    DDLog(@"dic3_%@",dic3);
//    2019-08-26 18:54:36.504000+0800【line -305】-[TestViewController funtionMoreDic] dic3_{
//        3 = 222;
//        2 = 222;
//    }
```
[Swift 高阶函数自定义](https://www.jianshu.com/p/8ebc559c9041)
