//
//  ViewController.m
//  KVODemo
//
//  Created by 杨强 on 10/5/2019.
//  Copyright © 2019 杨强. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "TestClass.h"
#import "Person.h"
#import "NSObject+RRKVO.h"

@interface ViewController ()
/** person */
@property (nonatomic,strong) Person *p;
@end

//static NSArray *ClassMethodNames(Class c)
//{
//    NSMutableArray *array = [NSMutableArray array];
//
//    unsigned int methodCount = 0;
//    Method *methodList = class_copyMethodList(c, &methodCount);
//    unsigned int i;
//    for(i = 0; i < methodCount; i++)
//        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
//    free(methodList);
//
//    return array;
//}
//
//static void PrintDescription(NSString *name, id obj) {
//    NSString *str = [NSString stringWithFormat:
//                     @"%@: %@\n\tNSObject class %s\n\tlibobjc class %s\n\timplements methods <%@>",
//                     name,
//                     obj,
//                     class_getName([obj class]),
//                     class_getName(obj->isa),
//                     [ClassMethodNames(obj->isa) componentsJoinedByString:@", "]];
//    printf("%s\n", [str UTF8String]);
//}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self testTestClassKVO];
    
    Person *p = [Person new];
    _p = p;
    //使用自定义的KVO来监听！Person的name属性
    NSLog(@"改之前%@",[p class]);
    [p rr_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"改之后%@",[p class]);
    
}

#pragma mark - 监听到就来了
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"来到这，%@",_p.name);//这里会走重写的set方法
}
#pragma mark - 点击改变 name 的属性
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int i = 0;//加上static的目的是每次进来改变i的值。就不会重新初始化了
    i++;
    [self.p setValue:[NSString stringWithFormat:@"张%d",i] forKey:@"name"];
//    _p.name = ;
}

/*
//KVO系统的处理是通过运行时，替换了对象的isa指针对象，并重写了set等方法
- (void)testTestClassKVO {
    TestClass *x = [[TestClass alloc] init];
    TestClass *y = [[TestClass alloc] init];
    TestClass *xy = [[TestClass alloc] init];
    TestClass *control = [[TestClass alloc] init];

    [x addObserver:x forKeyPath:@"x" options:0 context:NULL];
    [xy addObserver:xy forKeyPath:@"x" options:0 context:NULL];
    [y addObserver:y forKeyPath:@"y" options:0 context:NULL];
    [xy addObserver:xy forKeyPath:@"y" options:0 context:NULL];

    PrintDescription(@"control", control);
    PrintDescription(@"x", x);
    PrintDescription(@"y", y);
    PrintDescription(@"xy", xy);

    printf("Using NSObject methods, normal setX: is %p, overridden setX: is %p\n",
           [control methodForSelector:@selector(setX:)],
           [x methodForSelector:@selector(setX:)]);
    printf("Using libobjc functions, normal setX: is %p, overridden setX: is %p\n",
           method_getImplementation(class_getInstanceMethod(object_getClass(control),
                                                            @selector(setX:))),
           method_getImplementation(class_getInstanceMethod(object_getClass(x),
                                                            @selector(setX:))));
}
*/

@end
