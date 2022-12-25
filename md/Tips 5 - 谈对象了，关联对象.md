## 前言

![double_xiang.jpeg](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2cd35441b82046aca0bbcb964a4ab554~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

关联对象是用来为分类添加成员变量时使用的，那么为什么分类需要使用关联对象来添加成员变量呢？那肯定是因为正常的添加成员变量的方式在分类中不能用。

一般我们在类中声明一个属性，代码是这样的：

```objc
@interface Animal: NSObject

@property (nonatomic, copy) NSString *name;

@end
复制代码
```

然后编译器会帮我们生成如下方法：

```objc
@implementation Animal {
    NSString *_name;
}

- (NSString *)name {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
}
复制代码
```

就是：

- 生成一个实例变量 `_name`
- 生成 `getter` 方法
- 生成 `setter` 方法

编译器帮我们生成了一个实例变量，然后存到在类结构中。

当我们尝试往一个分类中去添加一个属性：

```objc
@interface Animal (Category)

@property (nonatomic, copy) NSString *gender;
  
@end
复制代码
```

我们会得到以下警告：

![warnning.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ca1b71bf3e9943b79d4b69dd028c774c~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

```shell
Property 'gender' requires method 'gender' to be defined - use @dynamic or provide a method implementation in this category
复制代码
```

意思就是 `gender` 属性的存取方法需要自己去手动实现，或者使用 `@dynamic` 在运行时实现这些方法。

因为在分类中，虽然可以通过 `@property` 来添加属性，但是不会自动生成私有成员变量，也不会生成 `set` 和 `get` 方法，只会生成 `set`、`get` 的声明，具体的方法实现需要我们自己去实现。

## 从 Category 讲起

至于为什么不自动给分类生成私有成员变量，最直接的原因就是分类不支持，先来看看类的结构，它在源码中是一个名为 `objc_class` 的结构体：

```objc
struct objc_class {
    Class _Nonnull isa;
    
    struct objc_ivar_list * _Nullable ivars; // 成员变量列表
    struct objc_method_list * _Nullable * _Nullable methodLists; // 方法列表
    struct objc_protocol_list * _Nullable protocols; // 协议列表
    
    ...
}
复制代码
```

其中有三个成员：

- `ivars`：成员变量列表
- `methodLists`：方法列表
- `protocols`：协议列表

分类在源码中的结构如下，它是一个名为 `category_t` 的结构体：

```objc
struct category_t {
    const char *name; // 对应的类名
    
    WrappedPtr<method_list_t, method_list_t::Ptrauth> instanceMethods; // 实例方法列表
    WrappedPtr<method_list_t, method_list_t::Ptrauth> classMethods; // 类方法列表
    struct protocol_list_t *protocols; // 协议列表
    struct property_list_t *instanceProperties; // 属性列表
    
    ...
}
复制代码
```

它包含：

- `instanceMethods`：实例方法列表
- `protocols`：协议列表
- `instanceProperties`：属性列表

可以看到它是没有成员变量列表的，这就是为什么分类不允许添加成员变量的最直接的原因，从结构设计上就不支持。

为什么要这么设计呢？

其实得问苹果为什么要这么设计，我个人觉得设计成可以添加成员变量好像也没毛病？虽然我没想出来是为啥，不过还是放一份别人的答案，看懂的同学可以指点下：

> 总得来说就是，`Category` 是在运行时才会被运行时库（也就是 `Runtime`）加载到内存中，而类的内存布局在编译时就已经确定了，不可以再更改。
>
> 所以不允许添加成员变量，是因为添加成员变量会影响到 "类实例" 的内存布局，所谓 "类实例"，它就是我们创建出来的类对象，它是一块包含 `isa` 指针和所有的成员变量的内存区域，我们不能在运行时再去改变它，而成员变量的增加会直接影响到它的内存的，所以不允许在运行时再添加成员变量。
>
> 而方法/协议/属性不属于 "类实例" 这个概念，它们归类管，也就是 `objc_class`，不管如何增删，都不会影响到 "类实例" 的内存，所以可以随意增删。

具体的原因我还没想明白，但是不管咋说，从源码上看，苹果它就不支持你去在分类中添加成员变量，如果我们想达到向正常类那样去使用一个属性（会自动生成实例变量和 `set`/`get` 方法），那么我们可以借助关联对象（主角出场的有点晚）。

当然，关联对象和正常的成员变量在底层是大不一样的，不过使用关联对象实现的属性和正常的属性在使用上并无二致。

## 使用关联对象

在 `Animal` 的分类中添加一个 `age` 属性：

```objc
#import "objc/runtime.h"

@interface Animal (Category)

@property (nonatomic, copy) NSString *categoryName;

@end

@implementation Animal (Category)

- (void)setCategoryName:(NSString *)categoryName {
    objc_setAssociatedObject(self, @"categoryName", categoryName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)categoryName {
    return objc_getAssociatedObject(self, @"categoryName");
}

@end
复制代码
```

使用时：

```objc
Animal *animal = [[Animal alloc] init];
animal.categoryName = @"Tom";
NSLog(@"%@", animal.categoryName);
复制代码
```

控制台输出：

```shell
Tom
复制代码
```

就像正常属性一样进行使用即可。

## 关联对象的实现原理

通过上面的例子，可以看到两个关键的 api，`objc_setAssociatedObject` 和 `objc_getAssociatedObject`，一个是设置，一个是获取，我们到源码中看看它们做了什么。

```objc
void

objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
{
    _object_set_associative_reference(object, key, value, policy);
}
复制代码
```

老样子，又是调了另一个方法：

```objc
void
_object_set_associative_reference(id object, const void *key, id value, uintptr_t policy)
{
    DisguisedPtr<objc_object> disguised{(objc_object *)object}; // (1)
    ObjcAssociation association{policy, value}; // (2)
    
    AssociationsManager manager; (3)
    AssociationsHashMap &associations(manager.get()); (4)
    
    auto refs_result = associations.try_emplace(disguised, ObjectAssociationMap{});
    auto &refs = refs_result.first->second;
    auto result = refs.try_emplace(key, std::move(association));
    ...
    
    // 释放旧值
    association.releaseHeldValue();
}
复制代码
```

这里省略了部分代码，我们需要注意里面的几个类和数据结构，在具体分析代码之前，需要先了解它们的作用。

- DisguisedPtr
- ObjcAssociation
- AssociationsManager
- AssociationsHashMap
- ObjectAssociationMap

`DisguisedPtr` 是一个 `class`：

```objc
class DisguisedPtr {
    uintptr_t value;
    
    ...
}
复制代码
```

它只有一个成员，通过 `(1)` 我们可以看到，它传入的是 `object`，对应的就是 `objc_setAssociatedObject(self, @"categoryName", categoryName, OBJC_ASSOCIATION_COPY_NONATOMIC);` 中的 `self`。

也就是将 `self` 放到了一个类中。

再看 `ObjcAssociation`：

```objc
class ObjcAssociation {
    uintptr_t _policy;
    id _value;
    
    ...
}
复制代码
```

`ObjcAssociation` 只有两个成员，`_policy` 是 `objc_AssociationPolicy`，它是一个枚举：

```objc
typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
    OBJC_ASSOCIATION_ASSIGN = 0,
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
    OBJC_ASSOCIATION_RETAIN = 01401,
    OBJC_ASSOCIATION_COPY = 01403
};
复制代码
```

而 `value` 就是关联对象对应的值。

和 `DisguisedPtr` 类似，并且通过 `(2)` 可以看出，是将关联对象的 `OBJC_ASSOCIATION_COPY_NONATOMIC` 和关联对象的 `value`，也就是 `categoryName` 一起放入了这个对象。

接下来就是 `AssociationsManager`：

```objc
class AssociationsManager {
    using Storage = ExplicitInitDenseMap<DisguisedPtr<objc_object>, ObjectAssociationMap>;
    static Storage _mapStorage;

public:
    AssociationsManager()   { AssociationsManagerLock.lock(); }
    ~AssociationsManager()  { AssociationsManagerLock.unlock(); }
    
    AssociationsHashMap &get() {
        return _mapStorage.get();
    }

    static void init() {
        _mapStorage.init();
    }
};
复制代码
```

其中的 `AssociationsManagerLock` 是一个自旋锁：

```objc
spinlock_t AssociationsManagerLock;
复制代码
```

所以它有一个 `spinlock_t`（自旋锁）和 `AssociationsHashMap` 单例，在 `&get` 方法中返回的是一个全局的 `AssociationsHashMap` 单例，然后 `AssociationsManager` 通过持有一个 `spinlock_t` 来保证对 `AssociationsHashMap` 的操作是线程安全的。

`(4)` 中就是通过 `&get` 方法，拿到了 `AssociationsHashMap`。

`AssociationsHashMap` 的定义为：

```objc
typedef DenseMap<DisguisedPtr<objc_object>, ObjectAssociationMap> AssociationsHashMap;
复制代码
```

是一个 `[DisguisedPtr : ObjectAssociationMap]` 的字典，`ObjectAssociationMap` 的定义如下：

```objc
typedef DenseMap<const void *, ObjcAssociation> ObjectAssociationMap;
复制代码
```

是一个 `[void * : ObjcAssociation]` 的字典，而 `ObjcAssociation` 我们前面提到过，它存放了关联对象的修饰符和关联对象的值，也可以说它就是我们所说的 "关联对象" 实际在内存中的结构。

看到这里，我们可以得到关联对象的一个存储结构，以我们在 `Animal` 中的 `categoryName` 为例，如果将 `categoryName` 设置为 `Tom`，它在内存中是这么存储的：

![structure.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/73d1feccd817420792bbb8bc823f92a7~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp?)

所以关联对象是通过一个全局的单例类来管理的，存储的结构也是一个哈希表的结构，所以我们可以想象出来，当需要一个对象添加了关联对象，它会以线程安全的方式（加锁）存储到一个全局的表中，`key` 是对象的 id（地址），而 `value` 是关联对象的修饰符和值。

那么释放的时机我们也很容易推断出来，只需要在对象的析构方法中，去这个全局的表中以对象的 id 为 `key` 移除掉与它相关的关联对象即可。

从 `dealloc` 方法中去找：

`dealloc` -> `rootDealloc` -> `object_dispose` -> `objc_destructInstance` -> `_object_remove_assocations`，`_object_remove_assocations` 就是释放关联对象的方法，定义如下：

```objc
void
_object_remove_assocations(id object, bool deallocating)

{
    ...
}
复制代码
```

可以看到传入了析构对象本身（`object`），然后再根据 `object` 去全局的表中查找该 `object` 所对应的值，然后移除即可。

### 源码

分析完原理之后，我们来看一下 `objc_setAssociatedObject` 和 `objc_getAssociatedObject` 两个方法的具体实现。

```objc
void
_object_set_associative_reference(id object, const void *key, id value, uintptr_t policy)
{
    if (!object && !value) return;
    if (object->getIsa()->forbidsAssociatedObjects())
        _objc_fatal("objc_setAssociatedObject called on instance (%p) of class %s which does not allow associated objects", object, object_getClassName(object));
    DisguisedPtr<objc_object> disguised{(objc_object *)object};
    ObjcAssociation association{policy, value};
    association.acquireValue();

    bool isFirstAssociation = false;
    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());

        if (value) {  // a
            auto refs_result = associations.try_emplace(disguised, ObjectAssociationMap{});
            if (refs_result.second) {
                isFirstAssociation = true;
            }

            auto &refs = refs_result.first->second;
            auto result = refs.try_emplace(key, std::move(association));
            if (!result.second) {
                association.swap(result.first->second);
            }
        } else {
            auto refs_it = associations.find(disguised);
            if (refs_it != associations.end()) {
                auto &refs = refs_it->second;
                auto it = refs.find(key);
                if (it != refs.end()) {
                    association.swap(it->second);
                    refs.erase(it);
                    if (refs.size() == 0) {
                        associations.erase(refs_it);
                    }
                }
            }
        }
    }

    if (isFirstAssociation)
        object->setHasAssociatedObjects();

    association.releaseHeldValue();
}
复制代码
```

提个注意点就是 `// a` 处，分两种情况：

- `value != nil`，设置/更新关联对象的值
- `value == nil`，删除关联对象

将关联对象的值设置为 `nil` 的话，会去删除这个关联对象。

`objc_getAssociatedObject` 方法内部调用了 `_object_get_associative_reference`：

```objc
id
_object_get_associative_reference(id object, const void *key)
{
    ObjcAssociation association{};
    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());
        AssociationsHashMap::iterator i = associations.find((objc_object *)object);
        if (i != associations.end()) {
            ObjectAssociationMap &refs = i->second;
            ObjectAssociationMap::iterator j = refs.find(key);
            if (j != refs.end()) {
                association = j->second;
                association.retainReturnedValue();
            }
        }
    }
    return association.autoreleaseReturnedValue();
}
复制代码
```

只放了源码，没有具体到每一条的分析，个人觉得看个大概，理解原理就可以了。

## 总结

- 关联对象在源码中其实就是 `ObjcAssociation` 对象。
- `ObjcAssociation` 存放在 `ObjectAssociationMap` 中，然后以对象的指针为 `key`，`ObjectAssociationMap` 为 `value`，存放在 `AssociationsHashMap` 中。
- `AssociationsHashMap` 是一个哈希表，由 `AssociationsManager` 管理，`AssociationsManager` 是一个全局的单例，持有 `AssociationsHashMap`， `AssociationsHashMap` 也是全局唯一的一张表。
- 对象在析构函数中，通过 `has_assoc` 标记位判断对象是否有关联对象，有的话会调用 `_object_remove_assocations` 方法移除相关关联对象。

## 参考

[关联对象 AssociatedObject 完全解析](https://link.juejin.cn?target=https%3A%2F%2Fdraveness.me%2Fao%2F)



作者：_Terry
链接：https://juejin.cn/post/7171336669604347912
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。