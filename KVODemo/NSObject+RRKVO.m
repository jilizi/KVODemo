//
//  NSObject+RRKVO.m
//  KVODemo
//
//  Created by 杨强 on 10/5/2019.
//  Copyright © 2019 杨强. All rights reserved.
//

#import "NSObject+RRKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (RRKVO)

#pragma mark - 1.调用supper的set方法 2.通知外界
void setName(id self,SEL _cmd,NSString *newName){
    
    NSLog(@"运行这里");
    //调用父类的
    //保存子类类型
    id class = [self class];
    //改变self的isa指针
    object_setClass(self, class_getSuperclass(class));
    //调用父类的set方法
    objc_msgSend(self, @selector(setName:),newName);
    NSLog(@"修改完毕");
    //拿到观察者
    id objc = objc_getAssociatedObject(self, @"objc");
    //通知观察者
    objc_msgSend(objc, @selector(observeValueForKeyPath:ofObject:change:context:),self,@"name",nil,nil);
    //改回子类类型
    object_setClass(self, class);
    
}

//self 是 被观察者 （Person）
//observer 是 观察者
- (void)rr_addObserver:(NSObject *_Nullable)observer forKeyPath:(NSString *_Nullable)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    
    /*
     1、自定义子类对象
     2、重写setName:方法，调用super的，通知观察者
     3、修改当前对象的isa指针，只想自定义的子类
     */
    //1、动态生成一个类
    //1.1创建self的子类
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [@"rrKVO_" stringByAppendingString:oldClassName];
    const char *newName = [newClassName UTF8String];
    //创建一个类的class
    Class myClass = objc_allocateClassPair([self class], newName, 0);
    //注册类
    //就可以加入到内存中了 就可以用来alloc init了
    objc_registerClassPair(myClass);
    
    //2.添加set方法
    class_addMethod(myClass, @selector(setName:), (IMP)setName, "v@:@");//查看官方文档可得 cmd
    
    //3.修改isa指针
    object_setClass(self, myClass);
    
    //4.保存观察者对象
    objc_setAssociatedObject(self, @"objc", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//相当于给self动态的创建了一个属性
}

@end
