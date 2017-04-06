//
//  ZYPepple.m
//  Sort
//
//  Created by Shuaiqi Xue on 15/8/13.
//  Copyright (c) 2015年 www.zhiyou100.com 智游3G培训学院. All rights reserved.
//

#import "ZYPepple.h"

@implementation ZYPepple

//实现compare方法 自定义排序规则
- (NSComparisonResult)compare:(ZYPepple *)people
{
    NSLog(@"%@__%@", self.name, people.name);
    if (self.age<people.age)
    {
        //升序 self在前 people在后
        return NSOrderedAscending;
    }
    else
    {
        //people在前 self在后
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (NSString *)description
{
    return self.name;
}

@end





