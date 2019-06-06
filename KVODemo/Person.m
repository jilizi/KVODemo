//
//  Person.m
//  KVODemo
//
//  Created by 杨强 on 10/5/2019.
//  Copyright © 2019 杨强. All rights reserved.
//

#import "Person.h"

@implementation Person
//不影响重写set方法
-(void)setName:(NSString *)name{
    
    _name = [NSString stringWithFormat:@"在不影响重写set方法的情况下加上这句%@",name];
    
}
@end
