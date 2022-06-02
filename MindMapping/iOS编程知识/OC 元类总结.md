元类是什么?
OC中所有的类都一种对象。
元类就是类对象所属的类。

实例对象：当我们在代码中new一个实例对象时，拷贝了实例所属的类的成员变量，但不拷贝类定义的方法。调用实例方法时，根据实例的isa指针去寻找方法对应的函数指针。

类对象：是一个功能完整的对象。特殊之处在于它们是由程序员定义而在运行时由编译器创建的，它没有自己的实例变量（这里区别于类的成员变量，他们是属于实例对象的，而不是属于类对象的，类方法是属于类对象自己的），但类对象中存着成员变量与实例方法列表。

元类对象：OC 的类方法是使用元类的根本原因，因为其中存储着对应的类对象的类方法。其他时候都倾向于隐藏元类，因此真实世界没有人发送消息给元类对象。元类的定义和创建看起来都是编译器自动完成的，无需人为干涉。要获取一个类的元类，可使用如下定义的函数：
Class objc_getMetaClass(const char* name); //name为类的名字
此外还有一个获取对象所属的类的函数：
Class object_getClass(id obj) ;
由于类对象是元类的实例，所以当传入的参数为类名时，返回的就是指向该类所属的元类的指针。

①object_getClass跟随实例的isa指针，返回此实例所属的类，对于实例对象(instance)返回的是类(class),对于类(class)则返回的是元类(metaclass)。

②-class方法对于实例对象(instance)会返回类(class),但对于类(class)则不会返回元类(metaclass),而只会返回类本身，即[@”instance” class]返回的是__NSCFConstantString,而[NSString class]返回的是NSString。

③class_isMetaClass可判断某类是否为元类。

④使用objc_allocateClassPair可在运行时创建新的类与元类对，使用class_addMethod和class_addIvar可向类中增加方法和实例变量，最后使用objc_registerClassPair注册后，就可以使用此类了。这体现了OC作为运行时语言的强大之一：在代码运行中动态创建类并添加方法。

```
Class newClass = objc_allocateClassPair([NSError class], "RuntimeErrorSubclass", 0);
class_addMethod(newClass, @selector(addedMethod), (IMP)added_method_implentation, "v@:"); 
objc_registerClassPair(newClass);

void added_method_implentation(id self, SEL _cmd) 
{　　
　　//do something
}
```



